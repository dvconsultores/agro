const defaultColors = {
  white: '#fff',
  black: '#000',
  
  textGrey: '#b9b9b9',
  info: '#2196F3',
  error: '#df1278',
  success: '#75980b',
  warning: '#FFDD00',
}

const light = {
  dark: false,
  colors: {
    'background-app': '#F9F9F9',
    background: '#fafafa',
    'card-color': '#ffffff',
    surface: '#FFFFFF',
    foreground: '#4E444B',
    'foreground-2': '#46464F',

    primary: '#3278be',
    'primary-variant': '#3278be',
    'primary-darken': '#19334e',
    'primary-lighten': '#84b8eb',
    secondary: '#da6c6c',
    'secondary-lighten': '#eaadad',
    tertiary: '#c87b00',
    'tertiary-darken': '#623c00',
    accent: '#798c77',
    'accent-variant': '#a68a5b',

    label: '#777680',
    title: '#4E444B',
    'title-variant': '#47464A',
    'title-dark': '#151C52',
    outline: '#4E444B',

    ...defaultColors,
  },
}

const dark = {
  dark: true,
  colors: {
    ...defaultColors,
  },
}

export default { light, dark }
