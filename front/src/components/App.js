import React from 'react';
import Header from "./Header";
import Button from '@material-ui/core/Button';
import '../style/App.css';
import axios from 'axios';

// Needed to format indexes
/*eslint no-extend-native: ["error", { "exceptions": ["Number"] }]*/
Number.prototype.pad = function(size) {
  var s = String(this);
  while (s.length < (size || 2)) {s = "0" + s;}
  return s;
}

// LIFECYCLE
// load data
// prepare data to show
// show data
// wait for actions:
//   - click on item
//   - search through box (in the future)
//   ...
class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { 
      loading: false,
      data_sample: [],
      data_shown: [],
      current_ix_open: null,
      nest_state: "open",
      token: null,
    };
    this.add_ix_n_percent = this.add_ix_n_percent.bind(this);
    this.doIndentation = this.doIndentation.bind(this);
    this.getObjectsClassic = this.getObjectsClassic.bind(this);
    this.refresh = this.refresh.bind(this);
  };

  // Load data
  componentDidMount() {
    this.setState({ loading: true });
    const apiURL = process.env.REACT_APP_API_URL;
    const apiSignup = apiURL.concat(`/api/auth/signup`);
    const apiLogin = apiURL.concat(`/api/auth/login`);
    const apiGetMain = apiURL.concat(`/api/co2/get_main`);
    const apiGetCountries = apiURL.concat(`/api/co2/get_countries`);
    const apiGetSectors = apiURL.concat(`/api/co2/get_sectors`);
    var full_list = [];
    axios({
      method: 'post',
      url: apiSignup,
      data: {
        username: 'App',
        email: 'app@poliz.ai',
        password: 'test1234'
      }
    })
   .then((resp_signup) => {
      console.log("NEW SIGNUP");
      return axios({method: 'post', url: apiLogin, data: {username_or_email: 'App',password: 'test1234'}});
    }).then(resp_login => {
      console.log("NEW TOKEN");
      this.setState({
        token: resp_login.data.data.token
      });
      const apiConfig = {
         headers: {
            Authorization: "Bearer " + this.state.token
         }
      };
      return axios.get(apiGetMain, apiConfig)
    }).then((response) => {
      full_list.push(...this.add_ix_n_percent(response.data.data, ""));
      this.setState({ 
        loading: false, 
        current_ix_open: "000",
        data_sample: full_list 
      });
      const apiConfig = {
         headers: {
            Authorization: "Bearer " + this.state.token
         }
      };
      return axios.get(apiGetCountries, apiConfig);
    }).then(response_b => {
      full_list.push(...this.add_ix_n_percent(response_b.data.data, "000"));
      this.setState({ 
        loading: false, 
        current_ix_open: "000",
        data_sample: full_list 
      });
      const apiConfig = {
         headers: {
            Authorization: "Bearer " + this.state.token
         }
      };
      return axios.get(apiGetSectors, apiConfig);
    }).then(response_c => {
        full_list = this.add_ix_n_percent(response_c.data.data, this.state.data_sample);
        this.setState({ 
          loading: false, 
          current_ix_open: "000",
          data_sample: full_list,
          data_shown: this.getObjectsClassic() });
    }).catch(error => console.log(error));
  };

  // Prepare Data to Show
  getObjectsClassic() {
    var data_original = this.state.data_sample;
    var nest_state = this.state.nest_state;
    var result = [];

    var selected_key = this.state.current_ix_open;
    var selected_key_layers = selected_key.split("_");
    var selected_key_layer_nr = (selected_key.match(/_/g) || []).length;
    Object.keys(data_original).forEach(function(key){
      var k = data_original[key].ix;
      var key_layers = k.split("_");
      var key_layer_nr = (k.match(/_/g) || []).length;
      // Show parents
      for (let i =0; i < selected_key_layers.length; i++) {
        if (k === selected_key_layers.slice(0, i).join("_")) {
          var full_object = data_original[key];
          result.push(full_object);
        }
      }
      // SHow itself and children
      if (nest_state === "closed") {
        if (k === selected_key) {
          full_object = data_original[key];
          result.push(full_object);
        }
      } else {
        if ((k === selected_key) || ((k.includes(selected_key + "_")) && !( key_layer_nr > selected_key_layer_nr + 1))) {
          full_object = data_original[key];
          result.push(full_object);
        }
      }
      // Show "siblings"
      var key_parent = key_layers.slice(0, -1).join('_');
      var selected_key_parent = selected_key_layers.slice(0, -1).join('_');
      if ((key_layer_nr === selected_key_layer_nr) && !(k === selected_key) && 
        (key_parent === selected_key_parent)) {
          full_object = data_original[key];
          result.push(full_object);
      }
    })
    return result
  }
  getData2Show(selected_key) {
    var selected_key_degrees = (selected_key.match(/_/g) || []).length;
    var state_selected_key_degrees = (this.state.current_ix_open.match(/_/g) || []).length;
    if (selected_key === this.state.current_ix_open) {
      if (this.state.nest_state === "open") {
        var new_nest_state = "closed";
      } else {
        new_nest_state = "open";
      }
    } else {
      if (selected_key_degrees < state_selected_key_degrees) {
        new_nest_state = "closed";
      } else {
        new_nest_state = "open";
      }
    }
    this.setState({
      current_ix_open: selected_key,
      nest_state: new_nest_state,
    }, function () {
        var key_objects = this.getObjectsClassic();
        this.setState({
          data_shown: key_objects,
        })
    });
  }

  // Show data
  refresh() {
    var data_shown = this.state.data_shown;
    if (!this.state.isLoading) return <div style={{ display: "block", width: "100%", position:"absolute" }}> 
      <div> <Header name="testname" setName="testhandlename" />
      </div>
      <div style={{ display: "block", width: "100%", position: "relative", top: "3em" }}>
      <ul key="main_ul" style={{ display: "block", marginLeft: -30, marginRight: 10, width: '100%' }}>
        {data_shown.map(
          item => 
            <div className="button_main" key={item.ix} style={{ display: "block", marginLeft: this.doIndentation(item.ix) }}>
              <Button variant="contained" style={{display: "grid", width: "99%"}} onClick={this.getData2Show.bind(this, item.ix)}>
                <div className="button_name" style={{position: "absolute", alignSelf: "center", left: 0}} >{item.name}</div>
                <div className="button_amount" style={{alignSelf: "center"}}>{Math.round(item.amount_2019 * 10) / 10} Ton./Yr.</div>
                <div className="button_percent" style={{position: "absolute", right: 0, top: 0}} >{Math.round(item.percent_2019 * 10) / 10} % of Total</div>
                <div className="percent_bar" style={{ width: item.percent_2019 + "%" }} ></div>
              </Button>
            </div>
        )}
    </ul>
    </div>
    </div>;
    return (
      <div> <Header name="testname" setName="testhandlename" />
            <div style={{display: "block"}} className="button_main" >
              <Button variant="contained" style={{display: "grid", width: "99%"}}>
                <div className="button_name" style={{position: "absolute", alignSelf: "center", left: 0}} >
                  Give me a second, I am trying to fetch data...
                </div>
              </Button>
            </div>
      </div>
    );
  }

  render() {
    return (
      this.refresh()
    );
  }

  /// OTHER FUNCTIONS 
  doIndentation(this_key) {
    if (this_key !== undefined) {
      var count = (this_key.match(/_/g) || []).length;
      return count * 10;
    }
    return 0;
  };

  add_ix_n_percent(list, parents) {
    if (typeof(parents) === "string") {
      let result = [];
      let ctr = 0;
      list.forEach(function (item) {
        if (parents !== "") {
          item.ix = parents.concat("_").concat((ctr).pad(3));
        } else {
          item.ix = parents.concat((ctr).pad(3));
        };
        result.push(item);
        ctr += 1;
      });
      return result;
    } else if (typeof(parents) === "object") {
      let result = [];
      parents.forEach(function (p_item) {
        let ctr = 0;
        result.push(p_item);
        list.forEach(function (item) {
          if (item.country === p_item.name) {
            item.ix = p_item.ix.concat("_").concat((ctr).pad(3));
            item.percent_2019 = item.amount_2019 * 100 / p_item.amount_2019;
            result.push(item);
            ctr += 1;
          }
        });
      });
      return result;
    }
  };
}

export default App;
