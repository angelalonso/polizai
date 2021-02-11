import React, { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';
import List from './components/List';
import withListLoading from './components/withListLoading';

function App() {
  const ListLoading = withListLoading(List);
  const [appState, setAppState] = useState({
    loading: false,
    phrases: null,
  });

  useEffect(() => {
    setAppState({ loading: true });
    const apiUrl = `http://172.17.0.2:8000`;
    //const apiUrl = `https://api.github.com/users/hacktivist123/phrases`;
    axios.get(apiUrl).then((phrases) => {
      const allphrases = phrases.data;
      setAppState({ loading: false, phrases: allphrases });
    });
  }, [setAppState]);
  return (
    <div className='App'>
      <div className='container'>
        <h1>My phrases</h1>
      </div>
      <div className='phrase-container'>
        <ListLoading isLoading={appState.loading} phrases={appState.phrases} />
      </div>
      <footer>
        <div className='footer'>
          Built{' '}
          <span role='img' aria-label='love'>
            💚
          </span>{' '}
        </div>
      </footer>
    </div>
  );
}

export default App;
