const defaultColors = {
  white: '#fff',
  black: '#000',
  
  textGrey: '#b9b9b9',
  info: '#2196F3',
  error: '#FF5100',
  success: '#008000',
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

    primary: '#001689',
    'primary-variant': '#0B1F8E',
    'primary-darken': '#3B4279',
    'primary-lighten': '#0D154B',
    secondary: '#FF5100',
    'secondary-lighten': '#FF8B65',
    tertiary: '#F7E388',
    'tertiary-darken': '#C5AA00',
    accent: '#ff0000',
    'accent-variant': '#EFB8C8',

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
