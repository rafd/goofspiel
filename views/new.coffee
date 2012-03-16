form method:"post", action:"/create", ->
  ul ->
    li ->
      label "name"
      input type:"text", name:"bot[name]"
    li -> 
      label "secret"
      input type:"text", name:"bot[secret]"
    li ->
      label "code"
      textarea name:"bot[code]"
    li ->
      input type:"submit", value:"submit"