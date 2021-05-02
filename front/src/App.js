import React from 'react';
import Button from '@material-ui/core/Button';
import './App.css';
import { inData } from "./data";

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { 
      open: "00",
      in_data: inData,
      shown_data: inData,
    };
    this.doIndentation = this.doIndentation.bind(this);
    this.getObjects = this.getObjects.bind(this);
    this.refresh = this.refresh.bind(this);
  }

  doIndentation(this_key) {
      var count = (this_key.match(/_/g) || []).length;
      return count * 10;
    }

  getObjects(selected_key, nest_state) {
    var data_sample = this.state.in_data;
    var selected_arr = [];
    var currently_open = this.state.open;
    Object.keys(data_sample).forEach(function(key){
      var k = data_sample[key].k;
      if (nest_state === "closed") {
        if (k === selected_key) {
          var full_object = data_sample[key];
          selected_arr.push(full_object);
        }
      } else {
        var key_degrees = (k.match(/_/g) || []).length;
        var selected_key_degrees = (selected_key.match(/_/g) || []).length;
        if ((k === selected_key) || ((k.includes(selected_key + "_")) && !( key_degrees > selected_key_degrees + 1))) {
          var full_object = data_sample[key];
          selected_arr.push(full_object);
        }
      }
    })
    return selected_arr
  }

  getKey(selected_key) {
    var nest_state = "open";

    var key_objects = this.getObjects(selected_key, nest_state);
    this.setState({
      shown_data: key_objects,

    })
    this.render();

  }

  refresh() {

    var data_sample = this.state.shown_data;
    return <ul key="main_ul" style={{ marginLeft: -30 }}>
        {data_sample.map(
          item => 
            <div key={item.key} className="button_main" style={{ marginLeft: this.doIndentation(item.k) }}>
              <Button variant="contained" onClick={this.getKey.bind(this, item.k)}>
                <div className="button_name">{item.name}</div>
                <div className="button_amount">Amount: {item.amount}</div>
                <div className="button_percent">Percent: {item.percent}</div>
              </Button>
            </div>
        )}
      </ul>;
    }

  componentWillMount() {
    var key_objects = this.getObjects("00", "open");
    this.setState({
      shown_data: key_objects,

    })
  }

  render() {
    return this.refresh();
    }
}

export default App;
