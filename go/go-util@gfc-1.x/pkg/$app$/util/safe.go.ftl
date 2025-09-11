<#if license??>
${go.license(license)}
</#if>
package util

import (
  "fmt"
  "math/big"
  "strconv"
  "strings"
  "time"
)

/*!
** safeString converts various numeric and time types to strings safely.
*/
func safeString(val interface{}) *string {
  if val == nil {
    return nil
  }

  switch v := val.(type) {
  case int:
    str := strconv.Itoa(v)
    return &str
  case int64:
    str := strconv.FormatInt(v, 10)
    return &str
  case *int:
    if v == nil {
      return nil
    }
    str := strconv.Itoa(*v)
    return &str
  case *int64:
    if v == nil {
      return nil
    }
    str := strconv.FormatInt(*v, 10)
    return &str
  case big.Float:
    str := v.Text('f', -1)
    return &str
  case *big.Float:
    if v == nil {
      return nil
    }
    str := v.Text('f', -1)
    return &str
  case time.Time:
    str := v.Format(time.RFC3339)
    return &str
  default:
    return nil
  }
}


/*!
** safeInteger converts a string or int64 to an integer safely
*/
func safeInteger(val interface{}) *int {
  if val == nil {
    return nil
  }

  switch v := val.(type) {
  case string:
    i, err := strconv.Atoi(v)
    if err != nil {
      return nil
    }
    return &i
  case int64:
    i := int(v)
    return &i
  case *int64:
    if v == nil {
      return nil
    }
    i := int(*v)
    return &i
  case int:
    return &v
  case *int:
    if v == nil {
      return nil
    }
    return v
  default:
    return nil
  }
}

/*!
** safeLong converts a string or int to a long safely
*/
func safeLong(val interface{}) *int64 {
  if val == nil {
    return nil
  }

  switch v := val.(type) {
  case string:
    i, err := strconv.ParseInt(v, 10, 64)
    if err != nil {
      return nil
    }
    return &i
  case int:
    i := int64(v)
    return &i
  case *int:
    if v == nil {
      return nil
    }
    i := int64(*v)
    return &i
  case int64:
    return &v
  case *int64:
    if v == nil {
      return nil
    }
    return v
  default:
    return nil
  }
}

/*!
** safeBigDecimal converts a string to a BigDecimal safely
*/
func safeBigDecimal(val string) *big.Float {
  if val == "" {
    return nil
  }
  f, _, err := big.ParseFloat(val, 10, 0, big.ToNearestEven)
  if err != nil {
    return nil
  }
  return f
}

/*!
** safeDate converts a string or int64 to a time.Time (Date part only) safely.
** Expects format "YYYY-MM-DD"
*/
func safeDate(val interface{}) *time.Time {
  if val == nil {
    return nil
  }

  switch v := val.(type) {
  case string:
    t, err := time.Parse("2006-01-02", v)
    if err != nil {
      return nil
    }
    return &t
  case int64:
    t := time.Unix(v/1000, (v%1000)*1000000)
    return &t
  case *int64:
    if v == nil {
      return nil
    }
    t := time.Unix(*v/1000, (*v%1000)*1000000)
    return &t
  default:
    return nil
  }
}

/*!
** safeTime converts a string or int64 to a time.Time (Time part only) safely.
** Expects format "HH:MM:SS"
*/
func safeTime(val interface{}) *time.Time {
  if val == nil {
    return nil
  }
  switch v := val.(type) {
  case string:
    t, err := time.Parse("15:04:05", v)
    if err != nil {
      return nil
    }
    return &t
  case int64:
    t := time.Unix(v/1000, (v%1000)*1000000)
    return &t
  case *int64:
    if v == nil {
      return nil
    }
    t := time.Unix(*v/1000, (*v%1000)*1000000)
    return &t
  default:
    return nil
  }
}

/*
** safeTimestamp converts a string or int64 to a time.Time (full timestamp) safely
** Expects format "YYYY-MM-DD HH:MM:SS" or "YYYY-MM-DDTHH:MM:SS"
*/
func safeTimestamp(val interface{}) *time.Time {
  if val == nil {
    return nil
  }

  switch v := val.(type) {
  case string:
    s := v
    s = strings.ReplaceAll(s, "T", " ")
    if len(s) == 16 {
      s += ":00"
    }

    t, err := time.Parse("2006-01-02 15:04:05", s)
    if err != nil {
      return nil
    }
    return &t
  case int64:
    t := time.Unix(v/1000, (v%1000)*1000000)
    return &t
  case *int64:
    if v == nil {
      return nil
    }
    t := time.Unix(*v/1000, (*v%1000)*1000000)
    return &t
  default:
    return nil
  }
}

/*!
** safe converts an object to a specific type safely
*/
func safe[T any](val interface{}, clazz T) *T {
  if val == nil {
    return nil
  }
  if v, ok := val.(T); ok {
    return &v
  }

  str := fmt.Sprintf("%v", val)

  var zero T
  if str == "" || strings.TrimSpace(str) == "" {
    if _, ok := interface{}(zero).(string); ok {
      var zeroT T
      return &zeroT
    }
    return nil
  }

  switch interface{}(zero).(type) {
  case string:

    return (interface{}(str).(*T))
  case big.Float:
    b := safeBigDecimal(str)
    if b == nil {
      return nil
    }
    return (interface{}(*b).(*T))
  case time.Time:
    ts := safeTimestamp(str)
    if ts == nil {
      ts = safeDate(str)
    }
    if ts == nil {
      ts = safeTime(str)
    }
    if ts == nil {
      return nil
    }
    return (interface{}(*ts).(*T))
  case int:
    i := safeInteger(str)
    if i == nil {
      return nil
    }
    return (interface{}(*i).(*T))
  case int64:
    l := safeLong(str)
    if l == nil {
      return nil
    }
    return (interface{}(*l).(*T))
  default:
    return (interface{}(val).(*T))
  }
}

/*!
** safe converts a string to a specific type safely
*/
func safeStringConvert[T any](val string, clazz T) *T {
  if val == "" {
    return nil
  }
  var zero T
  str := val
  if str == "" || strings.TrimSpace(str) == "" {
    if _, ok := interface{}(zero).(string); ok {
      var zeroT T
      return &zeroT
    }
    return nil
  }

  switch interface{}(zero).(type) {
  case string:
    return (interface{}(str).(*T))
  case big.Float:
    b := safeBigDecimal(str)
    if b == nil {
      return nil
    }
    return (interface{}(*b).(*T))
  case time.Time:
    ts := safeTimestamp(str)
    if ts == nil {
      ts = safeDate(str)
    }
    if ts == nil {
      ts = safeTime(str)
    }
    if ts == nil {
      return nil
    }
    return (interface{}(*ts).(*T))
  case int:
    i := safeInteger(str)
    if i == nil {
      return nil
    }
    return (interface{}(*i).(*T))
  case int64:
    l := safeLong(str)
    if l == nil {
      return nil
    }
    return (interface{}(*l).(*T))
  default:
    return (interface{}(val).(*T))
  }
}

/*!
** safeMore applies safe to a list of objects
*/
func safeMore[T any](vals []interface{}, clazz T) []T {
  retVal := make([]T, 0, len(vals))
  for _, val := range vals {
    if safe(val, clazz) != nil {
      retVal = append(retVal, *safe(val, clazz))
    } else {
      var zero T
      retVal = append(retVal, zero)
    }
  }
  return retVal
}
