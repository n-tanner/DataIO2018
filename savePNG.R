# save the current plot as a png

savePNG = function(imageName){
  dev.copy(png, imageName)
  dev.off()
}