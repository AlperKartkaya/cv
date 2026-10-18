#let configuration = yaml("configuration.yaml")
#let settings = yaml("settings.yaml")

#show link: set text(blue)

#set page(
  paper: "a4",
  margin: (
    top: 1.5cm,
    bottom: 1cm,
  )
)

#show heading: h => [
  #set text(
    size: eval(settings.font.size.heading_large),
    font: settings.font.general
  )
  #h
]

#let optional-link(url, body) = {
  if url != none and url != "" {
    link(url)[#body]
  } else {
    body
  }
}

#let contact-row(icon, body) = par(justify: false)[
  #set text(fill: black)
  #box(width: 1.18em)[#icon]
  #body
]

#let contact-icon(path) = image(path, width: 0.85em)

#let photoThumb = [
  #box(
    width: 3.5cm,
    height: 3.82cm,
    clip: true,
  )[
    #image(
      "assets/photo.jpg",
      width: 3.5cm,
    )
  ]
]

#let sidebarSection = {[
  #set par(justify: true)

  #set text(
    size: eval(settings.font.size.contacts),
    font: settings.font.minor_highlight,
  )

  #let email = configuration.contacts.at("email", default: "")
  #if email != "" [
    #contact-row(contact-icon("assets/icon-mail.svg"), link("mailto:" + email)[#email])
  ]

  #let phone = configuration.contacts.at("phone", default: "")
  #if phone != "" [
    Phone: #link("tel:" + phone)[#phone] \
  ]

  #let linkedin = configuration.contacts.at("linkedin", default: none)
  #if linkedin != none and linkedin.at("url", default: "") != "" [
    #contact-row(contact-icon("assets/icon-linkedin.svg"), link(linkedin.url)[#linkedin.displayText])
  ]

  #let github = configuration.contacts.at("github", default: none)
  #if github != none and github.at("url", default: "") != "" [
    #contact-row(contact-icon("assets/icon-github.svg"), link(github.url)[#github.displayText])
  ]
  #line(length: 100%)

  = Profile

  #set text(
    eval(settings.font.size.education_description),
    font: settings.font.minor_highlight,
  )
  #par(justify: false)[
    #configuration.summary
  ]

  = Education

  #{
    for place in configuration.education [
      #par(justify: false)[
        #set text(
        size: eval(settings.font.size.heading),
        font: settings.font.general,
        )
        #if "to" in place and "from" in place [
          #place.from - #place.to \
        ] else if "arbitrary_interval" in place [
          #place.arbitrary_interval
        ]
        #optional-link(place.place.at("link", default: ""), [#place.place.name])
      ]
      #par(justify: false)[
        #set text(
          eval(settings.font.size.education_description),
          font: settings.font.minor_highlight,
        )
        #if "degree" in place and "major" in place [
          #place.degree #place.major
          #if "track" in place and place.track != "" [ (#place.track)]
          #linebreak()
        ]
        #if "gpa" in place [
          GPA: #place.gpa#linebreak()
        ]
        #if "location" in place [
          #place.location
        ]
      ]
    ]
  }

  = Skills

  #{
    for skill in configuration.skills [
      #par(justify: false)[
        #set text(
          size: eval(settings.font.size.description),
          tracking: -0.01em,
        )
        #set text(
          font: settings.font.minor_highlight,
          tracking: -0.01em,
        )
        *#skill.name*
        #linebreak()
        #skill.items.join(" • ")
      ]
    ]
  }
]}

#let mainSection = {[
  #grid(
    columns: (1fr, 4cm),
    column-gutter: 1em,
    [
      #par[
        #set text(
          size: eval(settings.font.size.heading_huge),
          font: settings.font.general,
        )
        *#configuration.contacts.name*
      ]
      #v(0.3em)
      #par[
        #set text(
          size: 12pt,
          font: settings.font.minor_highlight,
          top-edge: 0pt
        )
        #configuration.contacts.title
      ]
    ],
    move(dx: 0.4cm, photoThumb),
  )
  #v(-1.0cm)

  = Experience
  #v(0.15cm)

  #{
    for job in configuration.jobs [
      #let title-size = job.at("title_size", default: settings.font.size.heading)
      #set par(justify: false)
      #set text(
        size: eval(title-size),
        font: settings.font.general
      )
      *#job.position*
      #optional-link(job.company.at("link", default: ""), [\@ #job.company.name]) \
      #if "periods" in job [
        #set text(
          size: 10.5pt,
          font: settings.font.minor_highlight
        )
        #for period in job.periods [
          #period#linebreak()
        ]
      ] else if "period" in job [
        #set text(
          size: 10.5pt,
          font: settings.font.minor_highlight
        )
        #job.period
      ] else [
        #job.from - #job.to
      ]
      #v(-0.3em)

      #set text(
        size: eval(settings.font.size.description),
        font: settings.font.general
      )
      #list(..job.description)

      #if "tags" in job and job.tags.len() > 0 [
        #par(
          justify: false,
          leading: eval(settings.paragraph.leading),
        )[
          #set text(
            size: eval(settings.font.size.tags),
            font: settings.font.minor_highlight
          )
          #job.tags.join(" • ")
        ]
      ]
    ]
  }

  = Technical Focus

  #set text(
    size: eval(settings.font.size.description),
    font: settings.font.general
  )
  #list(..configuration.focus)

  = Selected Achievement

  #{
    for achievement in configuration.achievements [
      #set par(
        justify: true,
        leading: eval(settings.paragraph.leading)
      )
      #set text(
        size: eval(settings.font.size.description),
        font: settings.font.general
      )
      *#achievement.title* \
      #if "date" in achievement and achievement.date != "" [
        #set text(
          size: eval(settings.font.size.tags),
          font: settings.font.minor_highlight
        )
        #achievement.date \
      ]
      #set text(
        size: eval(settings.font.size.description),
        font: settings.font.general
      )
      #achievement.description
    ]
  }
]}

#{
  grid(
    columns: (2fr, 5fr),
    column-gutter: 3em,
    sidebarSection,
    mainSection,
  )
}
