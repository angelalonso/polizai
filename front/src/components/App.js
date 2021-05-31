import React, { useEffect, useState } from 'react';
import Header from "./Header";
import Button from '@material-ui/core/Button';
import '../style/App.css';
import axios from 'axios';
import NestedContent from './NestedContent';
import List from './List';
import withListLoading from './withListLoading';

// Needed to format indexes
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
    };
    this.add_ix = this.add_ix.bind(this);
    this.doIndentation = this.doIndentation.bind(this);
    this.getObjects = this.getObjects.bind(this);
    this.refresh = this.refresh.bind(this);
  };

  // Load data
  componentDidMount() {
    this.setState({ loading: true });
    const apiGetMain = `http://0.0.0.0:8000/api/co2-countries/get_main`;
    const apiGetCountries = `http://0.0.0.0:8000/api/co2-countries/get_countries`;
    const apiJWTToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2MjI0NjY3MTAsImV4cCI6MTYyMzA3MTUxMCwidXNlciI6InRlc3QiLCJsb2dpbl9zZXNzaW9uIjoiNjkxNDAxZjM4YWJhNGM1MWI4ODg1M2QxNGMwMjkzYjEifQ.kGPIVu3-H3IhBPfm5n29ipdaYIt3YEB2dbngobhIaf0"
    const apiConfig = {
       headers: {
          Authorization: "Bearer " + apiJWTToken
       }
    };
    var full_list = [];
    axios.get(apiGetMain, apiConfig)
      .then((response) => {
        full_list.push(...this.add_ix(response.data.data, ""));
        this.setState({ 
          loading: false, 
          current_ix_open: "000",
          data_sample: full_list });
        return axios.get(apiGetCountries, apiConfig);
    }).then(response_b => {
        full_list.push(...this.add_ix(response_b.data.data, "000"));
        this.setState({ 
          loading: false, 
          current_ix_open: "000",
          data_sample: full_list,
          data_shown: full_list });
    }).catch(error => console.log(error));
  };

  // Prepare Data to Show
  // TBD: show the ones needed
  getObjects(key) {
    let result = [];
    this.state.data_sample.forEach(function (item, index) {
      if (item.ix === key) {
        result.push(item);
      };
    });
    return result
  }
  getData2Show(selected_key) {
    var selected_key_degrees = (selected_key.match(/_/g) || []).length;
    var state_selected_key_degrees = (this.state.current_ix_open.match(/_/g) || []).length;
    if (selected_key === this.state.current_ix_open) {
      if (this.state.nest_state === "open") {
        var new_nest_state = "closed";
      } else {
        var new_nest_state = "open";
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
        var key_objects = this.getObjects(selected_key);
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
      <ul key="main_ul" style={{ display: "block", width: "100%", marginLeft: -30, marginRight: 10, width: '100%' }}>
        {data_shown.map(
          item => 
            <div key={item.ix} style={{display: "block"}} className="button_main" style={{ marginLeft: this.doIndentation(item.ix) }}>
              <Button variant="contained" style={{display: "grid", width: "99%"}} onClick={this.getData2Show.bind(this, item.ix)}>
                <div className="button_name" style={{position: "absolute", alignSelf: "center", left: 0}} >{item.country_name}</div>
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
      <p style={{ textAlign: 'center', fontSize: '30px' }}>
        Give me a second, I am trying to fetch data...
      </p>
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

  add_ix(list, parent_value) {
    let result = [];
    let ctr = 0;
    list.forEach(function (item) {
      if (parent_value != "") {
        item.ix = parent_value.concat("_").concat((ctr).pad(3));
      } else {
        item.ix = parent_value.concat((ctr).pad(3));
      };
      result.push(item);
      ctr += 1;
    });
    return result;
  };

}

export default App;
