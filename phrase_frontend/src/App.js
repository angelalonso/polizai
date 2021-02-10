import logo from './logo.svg';
import './App.css';
import dotenv from "dotenv";

function App() {
        var background = {backgroundSize : 'cover'};
        var textStyle = {
          position: 'absolute', 
          top: '50%', 
          left: '50%'
        };
        const API_URL = process.env.REACT_APP_ENV_API_URL;
      
    return (
        <div style={{width: 'auto'}}>
            <img 
              style={{backgroundSize : 'cover'}} responsive 
              src="http://www.milkbardigital.com.au/wp-content/uploads/2015/11/Milkbar-Home-Background.jpg"
            />
            <h1 style={textStyle}>{API_URL}</h1>
        </div>
    );
}

export default App;
