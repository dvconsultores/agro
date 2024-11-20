import moment from "moment"
import store from '@/store'
import imageCompression from 'browser-image-compression';
import variables from "@/mixins/variables";
const { defaultMaxDecimals, defaultLocale } = variables

export function mapRanged(value, {fromMin, fromMax, toMin, toMax, invert}) {
  invert ??= false

  let mappedValue =
      ((value - fromMin) / (fromMax - fromMin)) * (toMax - toMin) + toMin;

  mappedValue = Math.min(Math.max(mappedValue, toMin), toMax);
  return invert ? toMax + toMin - mappedValue : mappedValue;
}

export function createObserver({ options, targets, handle }) {
  options ??= {
    root: null,
    rootMargin: "0px",
    threshold: buildThresholdList(),
  };

  const observer = new IntersectionObserver(handle, options);
  if (targets instanceof HTMLElement) observer.observe(targets);
  else targets.forEach(el => observer.observe(el))

  return observer
}

/// Useful to set intersection threshold
export function buildThresholdList() {
  const thresholds = [];
  const numSteps = 20;

  for (let i = 1.0; i <= numSteps; i++) {
    const ratio = i / numSteps;
    thresholds.push(ratio);
  }

  thresholds.push(0);
  return thresholds;
}

export function showLoader() {
  store.commit('setLoaderState', true)
}

export function closeLoader() {
  store.commit('setLoaderState', false)
}

export function isArray(val) {
  return val.constructor.name == 'Array'
}

export function isNumber(val) {
  return typeof val == 'number'
}

export function isString(val) {
  return typeof val == 'string'
}

export function isOnlyDigits(value) {
  if (!value) return false
  const regex = /^[0-9.]+$/
  return regex.test(value.toString())
}

export function toCssVal(value, unit) {
  unit ||= 'px'

  if (isString(value)) {
    return value
  } else if (isNumber(value)) {
    return `${value}${unit}`
  } else if (isArray(value)) {
    const length = value.length

    // helper
    function setValue(val, i) {
      if (isString(val)) return val

      const def = `${val}${unit}`
      switch (length) {
        case 2: {
          if (i === 1) return `${val}em`
        } break;
        case 3: {
          if (i === 1) return `${val}vw`
        } break;
      }

      return def
    }

    const formatValue = value.map((e, i) => setValue(e, i)).join(',')

    switch (length) {
      case 1: return setValue(value.at(0))
      case 2: return `max(${formatValue})`
      default: return `clamp(${formatValue})`
    }
  }
}

export function capitalizeEachFirstWord(str) {
  if (!str) return str
  return str.split(" ").map((str) => capitalize(str)).join(" ");
}

export function capitalize(str) {
  if (!str) return str
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase()
}

export function getUrlFromFile(file) {
  if (!file) return null
  return URL.createObjectURL(file)
}

export async function getFileFromUrl(url, type) {
  type ||= 'image/jpeg' 

  const
    response = await fetch(url),
    blob = await response.blob(),
    filename = getFilenameFromUrl(url),
    file = new File([blob], filename, { type })
  
  return file
}

export function getFilenameFromUrl(url) {
  const path = url.split('/')

  // Gets the last part, which should be the name of the file
  return path[path.length - 1]
}

export async function getImageSize(file) {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();

    reader.onload = function(event) {
      const img = new Image();
      img.onload = function() {
        const width = img.width;
        const height = img.height;
        resolve({ width, height });
      };
      img.src = event.target.result;
    };
    reader.onerror = (error) => reject(error);

    reader.readAsDataURL(file);
  });
}

export function formatBytes(bytes, decimals) {
  decimals ||= 2

  if (bytes === 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  let i = Math.floor(Math.log(bytes) / Math.log(1024));
  return `${(bytes / Math.pow(1024, i)).toFixed(decimals)} ${suffixes[i]}`;
}

export function minutesToSeconds(minutes) {
  return minutes * 60
}

export function timeOf(time) {
  return moment(time.seconds * 1000)
}

export function timeFormatter(time) {
  return moment(time).format('DD/MM/YYYY HH:MM')
}

export function hourFormatter(time) {
  var seconds = Math.floor(time % 60);
  var minutes = Math.floor((time / 60) % 60);
  var hours = Math.floor((time / 3600) % 24);
  var days = Math.floor(time / (3600 * 24));

  var result = "";

  if (days > 0) result += days + "d "
  if (hours > 0) result += hours + "h "
  if (minutes > 0) result += minutes + "min "
  if (seconds > 0) result += seconds + "s"

  return result;
}

export function showMetaMapFlow(id) {
  const metadata = JSON.stringify({"id": id}),
  url = `https://signup.getmati.com/?merchantToken=${
    process.env.META_MAP_CLIENT_ID
  }&flowId=${
    process.env.META_MAP_FLOW_ID
  }&metadata=${metadata}&redirect=${window.location.origin}/profile?success=true&target=_self`

  window.open(url, '_self')
}

export function commasToDots(value) {
  if (!value.includes(",")) return value;

  let splitted = value.split(",");
  if (splitted.length > 2) {
    const intire = splitted[0];
    splitted = splitted.filter((element) => element !== "" && element !== intire);
    return `${intire},${splitted.join("")}`;
  } else {
    return splitted.join(".");
  }
}

export function maxDecimals(value, max) {
  max ||= defaultMaxDecimals

  if (!value || value === '0') return 0
  else if (Number(value) % 1 == 0) return value

  const splitted = value.toString().split("."),
    decimalsFiltered = splitted[1].substring(0, splitted[1].length > max ? max : splitted[1].length);

  splitted.pop();
  splitted.push(decimalsFiltered);
  return parseFloat(splitted.join("."));
}

export function getDecimalSeparator(locale) {
  const formatter = new Intl.NumberFormat(locale),
    testNumber = 1.1,
    formatedNumber = formatter.format(testNumber),
    separator = formatedNumber[1];

  return separator;
}

export function formatAmount(value, {
  symbol,
  symbolSuffixed = true,
  currency,
  locale = defaultLocale,
  maxDecimals = defaultMaxDecimals,
  minimumFractionDigits = defaultMaxDecimals,
  compact = false,
  removeThousandSeparator
}) {
  // Parse the string as a number. If parsing fails, use 0.0.
  value = parseFloat(Number(value).toString().replace(",", "")) || 0.0;

  // Use the Intl.NumberFormat API to format the value.
  let formatter

  if (compact) {
    formatter = new Intl.NumberFormat(
      'en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 1,
      notation: 'compact',
      compactDisplay: 'short',
    });
  } else if (currency) {
    formatter = new Intl.NumberFormat(
      locale, {
      style: 'currency',
      currency: currency,
      minimumFractionDigits: minimumFractionDigits,
      maximumFractionDigits: maxDecimals,
    });
  } else {
    formatter = new Intl.NumberFormat(
      locale, {
      minimumFractionDigits: minimumFractionDigits,
      maximumFractionDigits: maxDecimals,
    });
  }

  let formattedValue = formatter.format(value).trim();

  if (symbol) {
    formattedValue = formattedValue.replace(/[^0-9.,\s]+/g, symbol)

    if (symbolSuffixed) {
      formattedValue = `${formattedValue}${symbol}`
    } else {
      formattedValue = `${symbol}${formattedValue}`
    }
  }

  if (removeThousandSeparator) {
    const thousandSeparator = getDecimalSeparator(locale) === ',' ? '.' : ','
    formattedValue = formattedValue.split(thousandSeparator).join('')
  }

  return formattedValue
}

export function unformatAmount(formattedValue, {
  symbol,
  locale = defaultLocale,
  symbolSuffixed = true,
}) {
  if (!formattedValue) return 0

  if (symbol && symbolSuffixed) {
    formattedValue = formattedValue.slice(0, -symbol.length)
  }
  else if (symbol) {
    formattedValue = formattedValue.slice(symbol.length)
  }

  if (getDecimalSeparator(locale) === ',') {
    formattedValue = formattedValue.replaceAll('.', '')
    formattedValue = formattedValue.replace(',', '.')
  } else {
    formattedValue = formattedValue.replaceAll(',', '')
  }

  return parseFloat(formattedValue)
}

export async function fileCompression(file, options) {
  const blob = await imageCompression(file, options || {
    maxSizeMB: 1,
    maxWidthOrHeight: 1920,
    useWebWorker: true,
    initialQuality: 0.7,
  })

  return new File([blob], blob.name)
}

export function delayed(timeout, callback) {
  return new Promise((resolve, reject) => {
    try {
      setTimeout(() => resolve(callback ? callback() : null), timeout);
    } catch (error) {
      reject(error);
    }
  });
}

/// filtering input formatter
export function filteringInputformatter(event, allowedRegExp) {
  const input = event.target
  let value = input.value

  value = value.split('').filter(char => char.match(allowedRegExp)).join('');

  input.value = value;
  input.blur()
  input.focus()

  return value
}

/// restringed input formatter
export function restringedInputFormatter(event, blacklist) {
  const input = event.target;
  let value = input.value;

  value = value.split('').filter(char => !blacklist.includes(char)).join('');

  input.value = value;
  input.blur();
  input.focus();

  return value;
}

/// input formatter
export function decimalInputformatter(event, maxDecimals) {
  maxDecimals ||= defaultMaxDecimals

  console.log(event);

  const input = event.target
  let value = input.value

  if (!new RegExp(`^(\\d+([.,]\\d{0,${maxDecimals}})?)?$`).test(value)) value = value.slice(0, -1)
  value = value.split('.').join(',');

  input.blur()
  input.focus()

  return value
}
