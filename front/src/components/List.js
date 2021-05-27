import React from 'react';
const List = (props) => {
  const { repos } = props;
  if (!repos || repos.length === 0) return <p>No repos, sorry</p>;
  console.log("REPOS");
  console.log(repos);
  return (
    <ul>
      <h2 className='list-head'>Available Public Repositories</h2>
      {repos.data.map((repo) => {
        return (
          <li className='list'>
            <span className='repo-text'>{repo.country_name} </span>
            <span className='repo-description'>{repo.amount_2019}</span>
            <span className='repo-description'>{repo.percent_2019}</span>
          </li>
        );
      })}
    </ul>
  );
};
export default List;
