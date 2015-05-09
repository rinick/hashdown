# Custom CSS

Inline css is also allowed in markdown, you can use almost any css style that works  in a html page.

## Background

black background and white text

<style>
body{
 background:url("hashdown.png");
}
.markdown{
 background: -webkit-linear-gradient(-45deg,  #4c4c4c 0%,#666666 25%,#474747 39%,#111111 60%,#131313 100%);
 background: linear-gradient(135deg,  #4c4c4c 0%,#666666 25%,#474747 39%,#111111 60%,#131313 100%);
 color:white;
}
.markdown h1,.markdown h2,.markdown h3 {
color:white;
}
</style>

## Web Font

<link href='http://fonts.googleapis.com/css?family=Indie+Flower' rel='stylesheet' type='text/css'>

<span style="font-family:'Indie Flower',cursive;font-size:20px">Indie Flower font</span>

## Animation

<style>
#animated
{
position:relative;
background:#AAAAAA;
animation:animated_div 5s infinite;
-webkit-animation:animated_div 5s infinite;
border-radius:5px;
}

@keyframes animated_div
{
0%    {transform: rotate(0deg);left:0px;}
50%   {transform: rotate(0deg);left:500px;}
70%   {transform: rotate(0deg);left:500px;background:#ffffff;}
100%  {transform: rotate(-360deg);left:0px;}
}

@-webkit-keyframes animated_div
{
0%    {-webkit-transform: rotate(0deg);left:0px;}
50%   {-webkit-transform: rotate(0deg);left:500px;}
70%   {-webkit-transform: rotate(0deg);left:500px;background:#ffffff;}
100%  {-webkit-transform: rotate(-360deg);left:0px;}
}

</style>

<img src="hashdown.png" id="animated">