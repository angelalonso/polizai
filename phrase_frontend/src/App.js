import logo from './logo.svg';
import './App.css';

function App() {
        var background = {backgroundSize : 'cover'};
        var textStyle = {
          position: 'absolute', 
          top: '50%', 
          left: '50%'
        };
      
    return (
        <div style={{width: 'auto'}}>
            <img 
              style={{backgroundSize : 'cover'}} responsive 
              src="http://www.milkbardigital.com.au/wp-content/uploads/2015/11/Milkbar-Home-Background.jpg"
            />
            <h1 style={textStyle}>Text over image</h1>
        </div>
    );
}

export default App;
