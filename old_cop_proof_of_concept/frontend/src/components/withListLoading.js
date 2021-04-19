import React from 'react';
function WithListLoading(Component) {
  return function WihLoadingComponent({ isLoading, ...props }) {
    if (!isLoading) return <Component {...props} />;
    return (
      <p style={{ textAlign: 'center', fontSize: '30px' }}>
        Stay where you are for a second, your ugly face makes it hard to focus...
      </p>
    );
  };
}
export default WithListLoading;
