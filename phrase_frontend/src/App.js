import logo from './logo.svg';
import './App.css';
import dotenv from "dotenv";
import axios from "axios";
import React, { useState, useEffect } from "react";
import Async from 'react-async';

const loadUsers = () =>
  fetch("http://172.17.0.2:8000")
    .then(res => (res.ok ? res : Promise.reject(res)))
    .then(res => res.text())

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
    <div className="container">
      <Async promiseFn={loadUsers}>
        {({ data, err, isLoading }) => {
          if (isLoading) return "Loading..."
          if (err) return `Something went wrong: ${err.message}`

          if (data)
            return (
              <div>
                <div>
                  <h2>React Async - Random Users</h2>
                </div>
                {data.map(user=> (
                  <div key={user} className="row">
                    <div className="col-md-12">
                      <p>{user.name}</p>
                      <p>{user.email}</p>
                    </div>
                  </div>
                ))}
              </div>
            )
        }}
      </Async>
    </div>
        </div>
    );
}

export default App;
