import React, { Component } from 'react';

class AddEntry extends Component {
  addNewEntry(e) {
    e.preventDefault();
    var entry = {
      title: this.title.value,
      year: this.year.value,
      description: this.year.value
    }
    this.props.addEntry( entry );
  }

  render() {
    return (
      <form className="entry-form" onSubmit={(e) => this.addNewEntry(e)}>
        <p>Add an Entry</p>
        <input ref={ ( input ) => this.title = input } type="text" placeholder="Title" />
        <input ref={ ( input ) => this.year = input } type="text" placeholder="Year" />
        <textarea ref={ ( input ) => this.description = input } type="text" placeholder="Description" >
        </textarea>
        <button type="submit">Add Entry</button>
      </form>
    );
  }
}

export default AddEntry;
