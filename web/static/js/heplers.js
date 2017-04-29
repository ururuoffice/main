import R from 'ramda';

export const prependCssDimension = (dimensions) =>
  R.mapObjIndexed(value => `${value}px`, dimensions);

// export const toArrayWithKeyAsId = (obj) => Object.keys(obj).reduce((acc, curr) => {
//   const item = { ...obj[curr], id: curr }
//
//   acc.push(item)
//
//   return acc
// }, [])

export const toArrayWithKeyAsId = obj => R.reduce((acc, curr) => {
  const item = R.merge(obj[curr], { id: curr });
  acc.push(item);
  return acc;
}, [], R.keys(obj))