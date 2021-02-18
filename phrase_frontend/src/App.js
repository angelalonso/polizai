import './App.css';
import Async from 'react-async';
import React, { useState, useEffect } from "react";
import axios from 'axios';
import dotenv from "dotenv";
import logo from './logo.svg';
import withListLoading from './components/withListLoading';
import List from './components/List';
import background from './img/background.png';


//class App extends React.Component {
//  constructor() {
//    super();
//    this.state = {
//      posts: []
//    };
//    this.background = {backgroundSize : 'cover'};
//    this.textStyle = {
//      position: 'absolute', 
//      top: '50%', 
//      left: '50%'
//    };
//  }
// 
//
//  componentDidMount() {
//    axios
//      .get(
//        "http://172.17.0.2:8000"
//      )
//      .then(res => {
//        //console.log("res", res)
//        const posts = res.data
//        //debugger
//        this.setState({ posts });
//      })
//      .catch(error => {
//        console.log((error));
//      });
//  }
//
//  render() {
//  //console.log(this.state.posts)
//    return (
//      <div style={{width: 'auto'}}>
//        <img 
//          style={{backgroundSize : 'cover'}} responsive 
//          src="http://www.milkbardigital.com.au/wp-content/uploads/2015/11/Milkbar-Home-Background.jpg"
//      />
//      <h1 style={this.textStyle}>{{__html: this.state.posts}}</h1>
//    </div>
//    );
//  }
//}
//
//export default App;
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
    //<div className='App'>
    //  <div className='container'>
    //    <h1>My phrases</h1>
    //  </div>
    //  <div className='phrase-container'>
    //    <ListLoading isLoading={appState.loading} phrases={appState.phrases} />
    //  </div>
    //  <footer>
    //    <div className='footer'>
    //      Built{' '}
    //      <span role='img' aria-label='love'>
    //        
    //      </span>{' '}
    //    </div>
    //  </footer>
    //</div>

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
