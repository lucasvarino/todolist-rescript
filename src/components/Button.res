open Render

module Styles = {
  open Emotion

  let {toString: colorToString} = module(Theme.Colors)

  let button = css({
    "outline": "none",
    "border": "none",
    "color": Theme.Colors.white->colorToString,
    "backgroundColor": Theme.Colors.primary->colorToString,
    "minWidth": "10.5rem",
    "borderRadius": "6px",
    "height": "3.8rem",
    "fontSize": "1.6rem",
    "lineHeight": "2.1rem",
    "letterSpacing": "-0.035em",
    "cursor": "pointer",
    "transition": "300ms",
    "&:hover": {
      "backgroundColor": Theme.Colors.primaryDark->colorToString
    }
  })
}

@react.component
let make = (~children, ~onClick=?) =>
  <button ?onClick className=Styles.button> {children->s} </button>
