import React, { useEffect, useState } from 'react';
import Header from "./Header";
import '../style/App.css';
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
    const apiUrl = `http://0.0.0.0:8000/api/co2-countries/get_main`;
    const apiJWTToken = "xxx"
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
    <div style={{ display: "block", width: "100%", position:"absolute" }}> 
      <div> <Header name="testname" setName="testhandlename" />
      </div>
      <div style={{ display: "block", width: "100%", position: "relative", top: "3em" }}>
      <ul key="main_ul" style={{ display: "block", width: "100%", marginLeft: -30, marginRight: 10, width: '100%' }}>
        <ListLoading isLoading={appState.loading} repos={appState.repos} />

      </ul>
      </div>
    </div>
  );
}

export default App;
