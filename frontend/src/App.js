import './App.css';
import Async from 'react-async';
import React, { useState, useEffect } from "react";
import axios from 'axios';
import dotenv from "dotenv";
import logo from './logo.svg';
import withListLoading from './components/withListLoading';
import List from './components/List';
import background from './img/dirty.gif';

function App() {
  const ListLoading = withListLoading(List);
  const [appState, setAppState] = useState({
    loading: false,
    phrases: null,
  });

  useEffect(() => {
    document.title = "Trained Cop says"
    const apiUrl = process.env.REACT_APP_ENV_API_URL;
    setAppState({ loading: true });
    console.log(apiUrl)
    axios.get(apiUrl).then((phrases) => {
      const allphrases = phrases.data;
      setAppState({ loading: false, phrases: allphrases });
    });
  }, [setAppState]);
  return (

    <div >
        <div className='phrase-container' id='phrase'>
          <ListLoading isLoading={appState.loading} phrases={appState.phrases} />
        </div>
        <img id='image' src={background}/>
        <div id='bottom_msg' >
          ... said the trained cop!
        </div>
  </div>
  );
}

export default App;
