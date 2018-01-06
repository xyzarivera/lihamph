/**
 * @description
 * config.js
 */

module.exports = {
  azure: {
    storage: {
      account: process.env.LHM_STORAGE_ACCOUNT,
      key: process.env.LHM_STORAGE_KEY,
      container: 'lihamph'
    },
    cdn: {
      url: process.env.LHM_CDN_URL
    }
  }
};
