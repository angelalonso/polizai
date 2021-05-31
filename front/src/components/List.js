import React from 'react';
import Button from '@material-ui/core/Button';

function doIndentation(this_key) {
  var count = (this_key.match(/_/g) || []).length;
  return count * 10;
}

function getIx(selected_ix, current_ix) {
  console.log(selected_ix);
  console.log(current_ix);
  // TODO: be able to edit current_ix
}

const List = (props) => {
  const { response } = props;
  const { currentIx } = props;
  if (!response || response.length === 0) return <p>No response, sorry</p>;

  return (
    <ul>
      {response.map((item) => {
        return (
          <div key={item.ix} style={{display: "block"}} className="button_main" style={{ marginLeft: doIndentation(item.ix) }}>
            <Button variant="contained" style={{display: "grid", width: "99%"}} onClick={() => getIx(item.ix, currentIx)}>
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
