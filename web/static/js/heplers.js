import R from 'ramda';

export const prependCssDimension = (dimensions) =>
  R.mapObjIndexed(value => `${value}px`, dimensions)