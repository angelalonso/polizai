import React from 'react';
const List = (props) => {
  const { phrases } = props;
  if (!phrases || phrases.length === 0) return <p>No phrases, sorry</p>;
  return (
      <h2 className='list-head'>{phrases} </h2>
  );
};
export default List;
