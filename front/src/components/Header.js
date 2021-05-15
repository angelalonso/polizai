import React from "react";

import AppBar from "@material-ui/core/AppBar";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import ToggleButton from "@material-ui/lab/ToggleButton";
import ToggleButtonGroup from "@material-ui/lab/ToggleButtonGroup";


export default ({ name, setName }) => {
  return (
    <>
      <AppBar color="secondary">
        <Toolbar>
          <Typography variant="h6">
            Relative CO2 Footprints
          </Typography>
        </Toolbar>
      </AppBar>
    </>
  );
};

