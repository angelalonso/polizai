import React from 'react';
import Button from '@material-ui/core/Button';

function doIndentation(this_key) {
  var count = (this_key.match(/_/g) || []).length;
  console.log(count);
  return count * 10;
}

const List = (props) => {
  const { repos } = props;
  if (!repos || repos.length === 0) return <p>No repos, sorry</p>;


  return (
    <ul>
      {repos.data.map((item) => {
        return (
          <div key={item.key} style={{display: "block"}} className="button_main" style={{ marginLeft: doIndentation("00") }}>
            <Button variant="contained" style={{display: "grid", width: "99%"}} >
              <div className="button_name" style={{position: "absolute", alignSelf: "center", left: 0}} >{item.country_name}</div>
              <div className="button_amount" style={{alignSelf: "center"}}>{Math.round(item.amount_2019 * 10) / 10} Ton./Yr.</div>
              <div className="button_percent" style={{position: "absolute", right: 0, top: 0}} >{Math.round(item.percent_2019 * 10) / 10} % of Total</div>
              <div className="percent_bar" style={{ width: item.percent_2019 + "%" }} ></div>
            </Button>
          </div>
        );
      })}
    </ul>
  );
};
export default List;
