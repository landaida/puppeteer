const puppeteer = require('puppeteer');

(async function(){
	let browser = await puppeteer.launch({dumpio: true, args:['--no-sandbox']})
		console.log('after create new browser instance')
		let page = await browser.newPage()
		console.log('after create new page')
    try{
		await page.goto('https://en.wikipedia.org/wiki/Main_Page', {timeout:120000})
		console.log('after goto site')
		page.on('console', msg => console.log('PAGE LOG:', msg.text()));
		await page.screenshot({path: 'example1.png'});
		await page.waitFor('#mp-tfa p', {timeout:120000})
		console.log('after waitFor')
		await page.screenshot({path: 'example.png'});
		let competitions = await page.evaluate(()=>{return $('#mp-tfa p').text()}) 
		console.log('competitions:', competitions)
		console.log('after goto page')
		page.close()
		console.log('after close page')
	}catch(e){
		await page.screenshot({path: 'example3.png'});
		console.log(e.message)
	}
	process.exit()
})()
