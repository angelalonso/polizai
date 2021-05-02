import React from 'react';
import Button from '@material-ui/core/Button';
import './App.css';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = { open: "00" };
    this.testClick = this.testClick.bind(this);
    this.getObjects = this.getObjects.bind(this);
  }

  testClick() {
    console.log("TOUCHED");
  }

  getObjects() {
    var currently_open = this.state.open;
    console.log(currently_open);
  }

  render() {

    var new_data = { 
      "00": { 
        "name": "World",
        "amount": 100,
        "percent": 100,
        "childof": ""
      },
      "00_01": { 
        "name": "Germany",
        "amount": 60,
        "percent": 60,
        "childof": "00"
      },
      "00_01_01": { 
        "name": "Buildings",
        "amount": 60,
        "percent": 60,
        "childof": "00_01"
      },
      "00_01_02": { 
        "name": "Non Combustion",
        "amount": 60,
        "percent": 60,
        "childof": "00_01"
      },
      "00_01_03": { 
        "name": "Other Industrial Combustion",
        "amount": 60,
        "percent": 60,
        "childof": "00_01"
      },
      "00_01_04": { 
        "name": "Power Industry",
        "amount": 60,
        "percent": 60,
        "childof": "00_01"
      },
      "00_01_05": { 
        "name": "Transport",
        "amount": 60,
        "percent": 60,
        "childof": "00_01"
      },
      "00_02": { 
        "name": "France",
        "amount": 40,
        "percent": 40,
        "childof": "00"
      },
      "00_02_01": { 
        "name": "Buildings",
        "amount": 60,
        "percent": 60,
        "childof": "00_02"
      },
      "00_02_02": { 
        "name": "Non Combustion",
        "amount": 60,
        "percent": 60,
        "childof": "00_02"
      },
      "00_02_03": { 
        "name": "Other Industrial Combustion",
        "amount": 60,
        "percent": 60,
        "childof": "00_02"
      },
      "00_02_04": { 
        "name": "Power Industry",
        "amount": 60,
        "percent": 60,
        "childof": "00_02"
      },
      "00_02_05": { 
        "name": "Transport",
        "amount": 60,
        "percent": 60,
        "childof": "00_02"
      }
    }

    const getIndentation = function(key) {
      var count = (key.match(/_/g) || []).length;
      return count * 10;
    }

    var arr = [];
    Object.keys(new_data).forEach(function(key){
      var full_object = new_data[key];
      full_object['k'] = key;
      arr.push(full_object);
    })

    var shown_objects = this.getObjects();

    return <ul key="main_ul" style={{ marginLeft: -30 }}>
        {arr.map(
          item => 
            <div key={item.key} className="button_main" style={{ marginLeft: getIndentation(item.k) }}>
              <Button variant="contained" onClick={this.getObjects}>
                <div className="button_name">{item.name}</div>
                <div className="button_amount">Amount: {item.amount}</div>
                <div className="button_percent">Percent: {item.percent}</div>
                <div className="button_percent">Test: {item.indentation}</div>
              </Button>
            </div>
          //item => <MyAppChild indentation={getIndentation(item.k)} key={item.key} name={item.name} amount={item.amount} percent={item.percent} />
        )}
      </ul>;
    }
}


class MyAppChild extends React.Component {
  testClick() {
    console.log("TOUCHED");
  }

  render() {
    return <div key={this.props.key} className="button_main" style={{ marginLeft: this.props.indentation }}>
        <Button variant="contained" onClick={this.testClick}>
          <div className="button_name">{this.props.name}</div>
          <div className="button_amount">Amount: {this.props.amount}</div>
          <div className="button_percent">Percent: {this.props.percent}</div>
          <div className="button_percent">Test: {this.props.indentation}</div>
        </Button>
      </div>;
  }
}

export default App;
