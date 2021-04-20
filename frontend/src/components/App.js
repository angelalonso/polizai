import {initialEntries} from './entries';
import {additionalEntries} from './entries';
import React, { Component } from 'react';
import Header from './Header';
import Entry from './Entry';
import AddEntry from './AddEntry';
import '../style/App.css';

class App extends Component {
  constructor () {
    super();

    this.state = {
      entries: initialEntries
    };

    this.loadAdditionalEntries = this.loadAdditionalEntries.bind(this);
    this.addEntryToGallery = this.addEntryToGallery.bind(this);
  }

  loadAdditionalEntries() {
    var currentEntries = { ...this.state.entries };
    var newEntries = Object.assign( currentEntries, additionalEntries );

    this.setState({ entries: newEntries });
  }

  addEntryToGallery( entry ) {
    console.log( 'new entry: ', entry )
    var ts = Date.now();
    var newEntry = {};
    newEntry[ 'entry' + ts ] = entry;
    var currentEntries = { ...this.state.entries };
    var newEntries = Object.assign( currentEntries, newEntry );
    this.setState({ entries: newEntries });
  }

  render() {
    return (
      <div className="App">
        <Header text="Compare your actions with their impact worldwide"/>
        <p className="App-intro">
          Check the different Topics
        </p>
        <div className="entries">
        {
          Object
            .keys(this.state.entries)
            .map(key => <Entry key={key} meta={this.state.entries[key]} />)

        }
        </div>
        <div className="add-entries">
          <button onClick={this.loadAdditionalEntries}>Load more...</button>
        </div>
        <AddEntry addEntry={this.addEntryToGallery} />
      </div>
    );
  }
}

export default App;
