# Visual::Qrcode

`Visual::Qrcode` gives you various tools to generate working QRCodes with images in their backgrounds, based on [this research](https://cgv.cs.nthu.edu.tw/Projects/Recreational_Graphics/Halftone_QRCodes/).

Example of the marianne Visual QRCode generated by the tests :

![image](/spec/images/marianne_visual_qrcode.png)

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add visual-qrcode

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install visual-qrcode


## Dependencies

`visual-qrcode` depends on two gems :

- [rqrcode_core](https://github.com/whomwah/rqrcode_core)
- [mini_magick](https://github.com/minimagick/minimagick)

> Make sur that you have the `ImageMagick` CLI installed on your computer to use `mini_magick`. See its [requirements](https://github.com/minimagick/minimagick?tab=readme-ov-file#requirements)


## Usage

The basic usage requires a string for the QRCode content and an `image_path` (or `image_url`). **Default size** : 3x the basic QRCode size generated with a high level of error correction.

```ruby
visual_qr_code = VisualQrcode::Qrcode.new("bonjour", "spec/images/marianne.png")

# Returns a MiniMagick::Image
image = visual_qr_code.as_png

# MiniMagick::Image has a write method to create an image file
image.write("./marianne_visual_qrcode.png")
```

You can also add a size parameter, in pixels. This size can't be smaller than the **Default  size**.

```ruby
visual_qr_code = VisualQrcode::Qrcode.new("bonjour by 280", "spec/images/marianne.png", size: 280)

visual_qrcode.as_png.write("./marianne_visual_qrcode_280x280.png")
```

## Design choices

### Padding

In order to have a nice visual, a padding is added on the image to keep it inside of the QRCode guide patterns. Also it helps to reckognize that the image _is_ a scannable QRCode and not just some random image.

### Resize method

The Visual QRCode will be generated at a mutiple of the **Default size**, and then reduced to the expected size to maintain a good background image quality.

> For example, if the Default size is 140px, and you want a 230px image, it will generate a 280px Visual QRCode and then reduce it to 230px.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Testing

Run `bundle exec rake` to run tests and lint. This is what runs in the CI.

You can also use `bundle exec guard` to run gard and listen to modified files to run the test

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JeSuisUnCaillou/visual-qrcode/issues.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
