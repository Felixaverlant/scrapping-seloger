request = require("request")
cheerio = require("cheerio")

pieces = "2"
maxPrice = "850"
minPrice = "500"
startingPage = "1"
apt = []

request "http://www.seloger.com/list.htm?ci=750056&idtt=1&idtypebien=1,2&nb_pieces="+pieces+"&pxmax="+maxPrice+"&pxmin="+minPrice+"&LISTING-LISTpg="+startingPage+"",
	(err,res,body) ->
		if !err && res.statusCode == 200
			$ = cheerio.load body

			$(".liste_resultat article").each ->
				$elem = $(@)

				title = $elem.find(".listing_infos h2 a").text()
				price = $elem.find(".price a.amount").text()
				link  = $elem.find(".listing_infos h2 a").attr("href")
				img   = if $elem.find(".listing_photo_container .ref img").attr("src")?  then $elem.find(".listing_photo_container .ref img").attr("src") else "http://static.poliris.com/z/produits/assets/images/sl/list/no_visual.png"
				sector = $elem.find(".listing_infos h2 a").text().split(",")[..].pop()
				

				request link, (err,res,body) ->
					if !err && res.statusCode == 200
						$ = cheerio.load body

						description = $(".detail__description p.description").text()

						$(".resume__liste_critere li.resume__critere").map( ->
							d=$(@).text()
							if d.match(/Pi[é|è|e]ces?/g)
								room = d
							else if d.match(/m²/g)
								surface = d
							else
								moreInfos = d
						)
						room = $(".resume__liste_critere li.resume__critere").eq(0).text()
						surface = $(".resume__liste_critere li.resume__critere").eq(1).text()
						neighborhood = $(".detail-title_subtitle").text().trim()

						apt.push({
							"title": title,
							"price":price,
							"link":link,
							"img":img,
							"sector":sector,
							"room":room,
							"surface":surface,
							"neighborhood":neighborhood
						})

						console.log(apt)