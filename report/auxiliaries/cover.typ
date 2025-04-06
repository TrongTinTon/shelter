#let t = toml("/templates.toml")

#let bordered-page(body) = {
  box(width: 100%, height: 100%, stroke: 2pt + black, inset: 1em, body)
}

#show: bordered-page
#set align(center)

#[
  #show: upper
  #set text(size: 15pt)

  *VIETNAM NATIONAL UNIVERSITY HO CHI MINH CITY\
  HO CHI MINH CITY UNIVERSITY OF TECHNOLOGY\
  FACULTY OF COMPUTER SCIENCE AND ENGINEERING*
]

#v(1fr)

#align(center, image("/static/logo.png", height: 5cm))


#[
  #set text(size: 15pt)
  #set align(center)

  *#upper(t.at("course").at("name"))*
]

#block(width: 100%, inset: (y: 2em), stroke: (y: 1pt))[
  #set text(weight: "bold", size: 16pt)
  #upper(t.at("title"))

  #set text(weight: "regular", size: 15pt)
  Major: Computer Science
]

#set text(weight: "regular", size: 15pt)
#grid(
  columns: (1fr, 1fr),
  rows: (2em, auto),
  column-gutter: .2cm,
  align(right, [Supervisors:]),
  align(
    left,
    for s in t.at("teachers") [
      #v(0.5em, weak: true)
      #s.at("name")
    ],
  ),
)

#lower[---o0o---]
#grid(
  columns: (1fr, 1fr),
  rows: (2em, auto),
  column-gutter: .2cm,
  align(right, [Students:]),
  align(
    left,
    for s in t.at("students") [
      #v(0.5em, weak: true)
      #s.at("name") - #s.at("id")
    ],
  ),
)

#v(1fr)

HCMC, #datetime.today().display("[month]/[year]")
