/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ['./js/**/*.js', '../lib/*_web/**/*.*ex', './node_modules/flowbite/**/*.js'],
    theme: {
        extend: {},
    },
    plugins: [require('flowbite/plugin')],
}