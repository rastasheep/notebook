// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const defaultTheme = require('tailwindcss/defaultTheme')

const fs = require("fs")
const path = require("path")

module.exports = {
  darkMode: 'class', // to be replaced
  content: [
    "./js/**/*.js",
    "../lib/notebook_web.ex",
    "../lib/notebook_web/**/*.*ex"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['iA Writer Duo S', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        brand: "#FD4F00",
      },
      typography: ({ theme }) => ({
        DEFAULT: {
          css: {
            maxWidth: '80ch',
            lineHeight: '1.5rem',
            fontFeatureSettings: 'normal',
            pre: {
              borderWidth: '1px',
              borderRadius: '0.75rem',
              borderColor : 'var(--tw-prose-pre-border)'
            },
            h1: {
              marginTop: '0',
              marginBottom: '0.5em',
              fontWeight: 'bold',
              fontStyle: 'normal',
              textDecoration: 'underline',
              textDecorationThickness: '1px',
            },
            h2: {
              marginTop: '0',
              marginBottom: '0.5em',
              fontWeight: 'bold',
              fontStyle: 'normal',
              textDecoration: 'underline',
              textDecorationThickness: '1px',
            },
            h3: {
              marginTop: '0',
              marginBottom: '0.5em',
              fontWeight: 'bold',
              fontStyle: 'italic',
            },
            h4: {
              marginTop: '0',
              marginBottom: '0.5em',
              fontWeight: 'bold',
            },
            h5: {
              marginTop: '0',
              marginBottom: '0.5em',
              fontWeight: 'bold',
              fontStyle: 'italic',
            },
          },
        },
        invert: {
          css: {
            pre: {
              borderColor : 'var(--tw-prose-invert-pre-border)'
            }
          },
        },
        zinc: {
          css: {
            '--tw-prose-body': theme('colors.zinc[700]'),
            '--tw-prose-links': theme('colors.sky[500]'),
            '--tw-prose-pre-code': 'var(--tw-prose-body)',
            '--tw-prose-pre-bg': theme('colors.white'),
            '--tw-prose-pre-border': theme('colors.zinc[300]'),
            '--tw-prose-invert-links': theme('colors.sky[500]'),
            '--tw-prose-invert-body': theme('colors.zinc[300]'),
            '--tw-prose-invert-pre-code': 'var(--tw-prose-invery-body)',
            '--tw-prose-invert-pre-bg': theme('colors.zinc[800]'),
            '--tw-prose-invert-pre-border': theme('colors.zinc[700]'),
          },
        },
      }),
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}
