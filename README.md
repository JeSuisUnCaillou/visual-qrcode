# VisualQrcode

`VisualQrcode` gives you various tools to generate working QR codes with images in their backgrounds, based on [this research](https://cgv.cs.nthu.edu.tw/Projects/Recreational_Graphics/Halftone_QRCodes/).

Example of some `VisualQrcode` generated by the tests :

![image](/spec/images/marianne_visual_qrcode.png)
![image](/spec/images/zidane_visual_qrcode.png)
![image](/spec/images/leaf_visual_qrcode.png)

Basically, each QR Code module is transformed into 9 pixels. The central pixel is the QR Code data, and the 8 other pixels around are used to display the background image.

![image](/docs/basic_to_visual_sample.png)

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

The basic usage requires a string for the QRCode content and an `image_path` (or `image_url`).

```ruby
visual_qr_code = VisualQrcode::Qrcode.new(
    "Taataaaa Yoyoyooooo ! Qu'est-ce que tu caches sous ton grand chapeauuuuuu !",
    "spec/images/marianne.png"
)

# Returns a MiniMagick::Image
image = visual_qr_code.as_png

# MiniMagick::Image has a write method to create an image file
image.write("./marianne_visual_qrcode.png")
```

**Default size** : Because we need 9 pixels in each QR Code module, the **minimum size** is **3x the minimum basic QRCode size**  with a high level of error correction. It varies with the amount of content you want to encode in the QR Code.

You can also add a size parameter, in pixels. This size can't be smaller than the **minimum  size**.

```ruby
visual_qr_code = VisualQrcode::Qrcode.new(
    "This is a leaf. Yeah. Big surprise, isn't it ?", 
    "spec/images/leaf.png", 
    size: 280
)

visual_qrcode.as_png.write("./leaf_visual_qrcode_280x280.png")
```

If you choose a size too small, you'll get an error informing you of the minimum size necessary for your content.

If your content is small and produces a QR Code of small size (big patterns, few modules), you can increase the amount of modules with the `qr_size` parameter. It corresponds to the [size option of RQRCodeCore](https://github.com/whomwah/rqrcode_core/tree/master?tab=readme-ov-file#options)

```ruby
visual_qr_code = VisualQrcode::Qrcode.new(
    "eh", 
    "spec/images/zidane.png", 
    qr_size: 10
)

visual_qrcode.as_png.write("./zidane_visual_qrcode_size_10.png")
```

## Design choices

### Padding

In order to have a nice visual, a padding is added on the image to keep it inside of the QRCode line patterns on top and on the left. Also it helps to reckognize that the image _is_ a scannable QRCode and not just some random image.

**By default, the padding is equal to 7 modules.**

If your image has enough transparency to dodge the QRCode lines, you can remove the padding with the `padding_modules: 0` option.

```ruby
visual_qr_code = VisualQrcode::Qrcode.new(
    "My leaf don't need no padding, it's a strong and independant leaf",
    "spec/images/leaf.png", 
    size: 280, 
    padding_modules: 0
)
```

You can also customize the padding if you want more or less modules than the default value.

### Resize method

The Visual QRCode will be generated at a mutiple of the **minimum size**, and then reduced to the expected size to maintain a good background image quality.

> For example, if the minimum size is 140px, and you want a 230px image, it will generate a 280px Visual QRCode and then reduce it to 230px.

### QRCode minimum Size

The minimum [size of RQRCodeCore](https://github.com/whomwah/rqrcode_core/tree/master?tab=readme-ov-file#options) used is 6 by default, to get enough space for the image to be visible inside the Visual QRCode.

But you can force it to a lower value if you want, with the `qr_size` option.

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
