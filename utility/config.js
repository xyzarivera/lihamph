/**
 * @description
 * config.js
 */

module.exports = {
  azure: {
    storage: {
      account: process.env.GULP_STORAGE_ACCOUNT,
      key: process.env.GULP_STORAGE_SECRET,
      container: process.env.GULP_STORAGE_CONTAINER
    },
    cdn: {
      url: process.env.GULP_STORAGE_CDN
    }
  }
};
