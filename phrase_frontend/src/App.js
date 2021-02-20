import './App.css';
import Async from 'react-async';
import React, { useState, useEffect } from "react";
import axios from 'axios';
import dotenv from "dotenv";
import logo from './logo.svg';
import withListLoading from './components/withListLoading';
import List from './components/List';
import background from './img/background.png';

function App() {
  const ListLoading = withListLoading(List);
  const [appState, setAppState] = useState({
    loading: false,
    phrases: null,
  });

  useEffect(() => {
    const envScript = document.createElement('script');
    envScript.src = "env-config.js";
    document.body.appendChild(envScript);


    setAppState({ loading: true });
    const apiUrl = process.env.REACT_APP_ENV_API_URL;
    console.log(apiUrl)
    axios.get(apiUrl).then((phrases) => {
      const allphrases = phrases.data;
      setAppState({ loading: false, phrases: allphrases });
    });
  }, [setAppState]);
  return (

    <div style={{width: 'auto'}}>
        <div className='phrase-container'>
          <ListLoading isLoading={appState.loading} phrases={appState.phrases} />
        </div>
      <img 
        style={{backgroundSize : 'cover'}} responsive 
        src={background}
      />
  </div>
  );
}

export default App;
