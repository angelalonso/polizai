import React from 'react';
const List = (props) => {
  const { phrases } = props;
  if (!phrases || phrases.length === 0) return <p>No phrases, sorry</p>;
  return (
    <ul>
      <h2 className='list-head'>Available Public Phrases</h2>
        return (
          <li className='list'>
            <span className='phrase-text'>{phrases} </span>
          </li>
    </ul>
  );
};
export default List;
