import logo from './logo.svg';
import './App.css';
import dotenv from "dotenv";
import axios from "axios";
import React, { useState, useEffect } from "react";


function App() {
    var background = {backgroundSize : 'cover'};
    var textStyle = {
      position: 'absolute', 
      top: '50%', 
      left: '50%'
    };
    const [userData, setUserData] = useState({});
    const API_URL = process.env.REACT_APP_ENV_API_URL;
    const getPhrase = async () => {
      const response = await axios.get(API_URL);
      setUserData(response.data);
      console.log(response.data);
    };
      
    return (
        <div style={{width: 'auto'}}>
            <img 
              style={{backgroundSize : 'cover'}} responsive 
              src="http://www.milkbardigital.com.au/wp-content/uploads/2015/11/Milkbar-Home-Background.jpg"
            />
            <h1 style={textStyle}>{getPhrase}</h1>
        </div>
    );
}

export default App;
