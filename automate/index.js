
import puppeteer from "puppeteer";

const getData = async()=>{

  const browser = await puppeteer.launch({headless:false,args:['/home/nived/.config/google-chrome/Default']})
  const page = await browser.newPage()
  await page.setViewport({width: 1080, height: 768});
  await page.goto('https://app.software.com/login')
  await page.click('.button_to')
  // await page.waitForSelector('#login_field')
  // await page.type('#login_field','nived-cv')
  // await page.type('#password','Nicvnicv187')
  // await page.click('.js-sign-in-button')
  // await page.waitForSelector('.highcharts-series-1')
  
  //   let text = document.querySelectorAll('.highcharts-point')
  //   text.forEach(async(x)=>{
  //     console.log('looping')
  //     await page.click(x)
  //   })

}
getData()