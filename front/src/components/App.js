import React, { useEffect, useState } from 'react';
import axios from 'axios';
import List from './List';
import withListLoading from './withListLoading';

function App() {
  const ListLoading = withListLoading(List);
  const [appState, setAppState] = useState({
    loading: false,
    repos: null,
  });

  useEffect(() => {
    setAppState({ loading: true });
    //TODO: this is just a test
    const apiUrl = `http://0.0.0.0:8000/api/co2-countries/get_main`;
    const apiJWTToken = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    const apiConfig = {
       headers: {
          Authorization: "Bearer " + apiJWTToken
       }
    };
    axios.get(apiUrl, apiConfig).then((repos) => {
      const allRepos = repos.data;
      setAppState({ loading: false, repos: allRepos });
    }).catch(error => console.log(error));
  }, [setAppState]);
  return (
    <div className='App'>
      <div className='container'>
        <h1>Per Country:</h1>
      </div>
      <div className='repo-container'>
        <ListLoading isLoading={appState.loading} repos={appState.repos} />
      </div>
    </div>
  );
}

export default App;
