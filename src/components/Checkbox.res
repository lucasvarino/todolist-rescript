@module("../assets/check-icon.svg") external checkIcon: string = "default"

module Styles = {
  open Emotion

  let fillAnimation = keyframes({
    "0": {
      "transform": "scale(0)",
    },
    "50%": {
      "transform": "scale(1.25)",
    },
    "100%": {
      "transform": "scale(1)",
    },
  })

  let checkboxWrapper = css({
    "cursor": "pointer",
    "> input": {
      "display": "none",
    },
    "> div": {
      "position": "relative",
      "width": "2.4rem",
      "height": "2.4rem",
      "border": `solid 1px ${Theme.Colors.primary->Theme.Colors.toString}`,
      "borderRadius": "6px",
      "> img": {
        "position": "absolute",
        "top": "0.5rem",
        "left": "0.4rem",
        "transform": "scale(0)",
      },
      "&:after": {
        "borderRadius": "4.5px",
        "content": "' '",
        "position": "absolute",
        "width": "100%",
        "height": "100%",
        "top": 0,
        "left": 0,
        "transform": "scale(0)",
        "background": Theme.Colors.primary->Theme.Colors.toString,
      },
    },
    "> input:checked + div": {
      "> img": {
        "z-index": "10",
        "animation": `${fillAnimation} 300ms forwards`,
        "animationDelay": "100ms",
      },
      "&:after": {
        "animation": `${fillAnimation} 300ms forwards`,
      },
    },
  })
}

@react.component
let make = (~checked=?, ~onChange=?) => {
  <label className=Styles.checkboxWrapper>
    <input ?checked ?onChange type_="checkbox" />
    <div> <img src=checkIcon alt="Checkbox Icon" /> </div>
  </label>
}
