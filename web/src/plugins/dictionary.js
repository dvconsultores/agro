export const APP_NAMES = {
  camelcase: 'sapAvicola',
  kedabcase: 'sap-avicola',
  snakecase: 'sap_avicola',
  capitalize: 'SAP Avícola',
  values: () => Object.values(APP_NAMES),
}

export const ALERT_TYPE = {
  success: "success",
  error: "error",
  values: () => Object.values(ALERT_TYPE),
}

export const SCROLL_TO = {
  top: Symbol,
  bottom: Symbol,
  values: () => Object.values(SCROLL_TO),
}
