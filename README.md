



<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/yatendra2001/Pikc-Scanner">
    <img src="assets/images/pikc_logo.png"  alt="Logo" width="200" height="80" >
  </a>
  <p align="center">
    An app that let's you know if a product is harmful or not based on it's ingredients.
    <br />
    <a href="https://youtu.be/LrnHIeX0i8I">View Prototype</a>
  </p>
</div>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://youtu.be/LrnHIeX0i8I)

Pikc is a cross-platform mobile application built using flutter that lets you scan ingredients behind packaged products (food and cosmetics) to figure out if it is toxins free or not. Users can either capture ingredients' picture through a camera or take a screenshot and upload it on Pikc.

### How Does It Work?

User selects or captures an image → this image is provided to google text recognition API → API converts this image into readable text and returns a string → string gets split into words → each word goes through a list of toxic chemicals → If this word is present in the toxic chemicals list, it gets displayed on the result screen otherwise product is good to buy


### Built With

This section should list any major frameworks/libraries used to bootstrap your project. Leave any add-ons/plugins for the acknowledgements section. Here are a few examples.

* [Dart](https://dart.dev/)
* [Flutter](https://flutter.dev/)
* [Firebase](https://firebase.google.com/)
* [BLoC](https://bloclibrary.dev/)
* [Adobe XD](https://www.adobe.com/in/products/xd.html)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started


### Prerequisites

Need latest flutter version with null safety and android v2 embedding
* flutter
  ```sh
  flutter upgrade
  ```

### Installation

1. Clone the repository from GitHub:

```bash
git clone https://github.com/yatendra2001/Pikc-Scanner.git
```

2. Get all dependencies:
```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Your Name - [@Yatendr67513831](https://twitter.com/Yatendr67513831) - contact@pikc.tech

Project Link: [https://github.com/yatendra2001/Pikc-Scanner](https://github.com/yatendra2001/Pikc-Scanner)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/yatendra2001/Pikc-Scanner.svg?style=for-the-badge
[contributors-url]: https://github.com/yatendra2001/Pikc-Scanner/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/yatendra2001/Pikc-Scanner.svg?style=for-the-badge
[forks-url]: https://github.com/yatendra2001/Pikc-Scanner/network/members
[stars-shield]: https://img.shields.io/github/stars/yatendra2001/Pikc-Scanner.svg?style=for-the-badge
[stars-url]: https://github.com/yatendra2001/Pikc-Scanner/stargazers
[issues-shield]: https://img.shields.io/github/issues/yatendra2001/Pikc-Scanner.svg?style=for-the-badge
[issues-url]: https://github.com/yatendra2001/Pikc-Scanner/issues
[license-shield]: https://img.shields.io/github/license/yatendra2001/Pikc-Scanner.svg?style=for-the-badge
[license-url]: https://github.com/yatendra2001/Pikc-Scanner/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/yatendra-kumar-r2001/
[product-screenshot]: assets/images/pikc_background.png

