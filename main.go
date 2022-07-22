package main

import (
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"time"
)

func main() {
	gin.SetMode(gin.ReleaseMode)
	router := gin.Default()
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"message": "Hi",
		})
	})
	router.GET("/complete/:currentPercentage", calculateTimeToBeAt80Percent)
	router.Run()
}
func calculateTimeToBeAt80Percent(c *gin.Context) {

	actual_battery_percentage, err := strconv.Atoi(c.Param("currentPercentage"))
	if err != nil {
		c.String(http.StatusBadRequest, "Value has to be numeric")
		return
	}
	const batteryCapacity float32 = 62
	const maxload float32 = 3.73 //Max Charging Current in KW
	const targetedLoad int = 80

	var toLoad int = targetedLoad - actual_battery_percentage
	var kwToLoad float32 = batteryCapacity * float32(toLoad) / 100.0

	var timeDuration float32 = (kwToLoad / maxload * float32(time.Hour))
	loc, _ := time.LoadLocation("Europe/Berlin")
	timein := time.Now().In(loc).Add(time.Duration(timeDuration)).Format("2.1.2006 15:04")

	c.String(http.StatusOK, timein)

}
