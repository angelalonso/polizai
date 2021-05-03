import React from 'react';
import Button from '@material-ui/core/Button';
import './App.css';
import { inData } from "./data";

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { 
      selected_key: "00",
      nest_state: "open",
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

  getObjects() {
    //TODO: rename these variables 
    var data_sample = this.state.in_data;
    var nest_state = this.state.nest_state;
    var selected_arr = [];

    var selected_key = this.state.selected_key;
    var selected_key_nest_levels = selected_key.split("_");
    var selected_key_degrees = (selected_key.match(/_/g) || []).length;
    Object.keys(data_sample).forEach(function(key){
      var k = data_sample[key].k;
      var key_degrees = (k.match(/_/g) || []).length;
      var key_nest_levels = k.split("_");
      // Show parents
      for (let i =0; i < selected_key_nest_levels.length; i++) {
        if (k === selected_key_nest_levels.slice(0, i).join("_")) {
          var full_object = data_sample[key];
          selected_arr.push(full_object);
        }
      }
      // Show "siblings"
      var key_parent = key_nest_levels.slice(0, -1).join('_');
      var selected_key_parent = selected_key_nest_levels.slice(0, -1).join('_');
      if ((key_degrees === selected_key_degrees) && !(k === selected_key) && 
        (key_parent === selected_key_parent)) {
          var full_object = data_sample[key];
          selected_arr.push(full_object);
      }
      // SHow itself and children
      if (nest_state === "closed") {
        if (k === selected_key) {
          var full_object = data_sample[key];
          selected_arr.push(full_object);
        }
      } else {
        if ((k === selected_key) || ((k.includes(selected_key + "_")) && !( key_degrees > selected_key_degrees + 1))) {
          var full_object = data_sample[key];
          selected_arr.push(full_object);
        }
      }
    })
    return selected_arr
  }

  getKey(selected_key) {
    var selected_key_degrees = (selected_key.match(/_/g) || []).length;
    var state_selected_key_degrees = (this.state.selected_key.match(/_/g) || []).length;
    if (selected_key === this.state.selected_key) {
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
      selected_key: selected_key,
      nest_state: new_nest_state,
    }, function () {
        var key_objects = this.getObjects();
        this.setState({
          shown_data: key_objects,
        })
    });
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

  componentDidMount() {
    var key_objects = this.getObjects();
    this.setState({
      shown_data: key_objects,

    })
  }

  render() {
    return this.refresh();
  }
}

export default App;
