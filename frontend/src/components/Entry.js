import React, { Component } from 'react';

class Entry extends Component {
  render() {
    return (
      <div className="entry">
        <h2>{ this.props.meta.title }</h2>
        <p>({ this.props.meta.year })</p>
        <p>({ this.props.meta.description })</p>
      </div>

    );
  }
}

export default Entry;
