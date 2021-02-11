import logo from './logo.svg';
import './App.css';
import dotenv from "dotenv";
import axios from "axios";
import React, { useState, useEffect } from "react";
import Async from 'react-async';

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      posts: []
    };
    this.background = {backgroundSize : 'cover'};
    this.textStyle = {
      position: 'absolute', 
      top: '50%', 
      left: '50%'
    };
  }
 

  componentDidMount() {
    axios
      .get(
        "http://172.17.0.2:8000"
      )
      .then(res => {
        //console.log("res", res)
        const posts = res.data
        //debugger
        this.setState({ posts });
      })
      .catch(error => {
        console.log((error));
      });
  }

  render() {
  //console.log(this.state.posts)
    return (
      <div style={{width: 'auto'}}>
        <img 
          style={{backgroundSize : 'cover'}} responsive 
          src="http://www.milkbardigital.com.au/wp-content/uploads/2015/11/Milkbar-Home-Background.jpg"
      />
      <h1 style={this.textStyle}>{{__html: this.state.posts}}</h1>
    </div>
    );
  }
}

export default App;
