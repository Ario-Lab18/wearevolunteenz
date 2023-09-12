import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

/*
git add <files>
git commit -m "<comment>"
git push origin main
*/

var orgs = [
  {
    'name': 'TEST ONLY Civil Air Patrol',
    'info': ['aerospace', 'space', 'stem', 'science', 'camps'],
    'address': '105 S. Hansell Street, Maxwell AFB, AL 36112',
    'website': 'https://www.gocivilairpatrol.com/',
    'email': 'ario.lab18@gmail.com',
  },
  {
    'name': 'TEST ONLY Adopt a Park',
    'info': [],
    'address': '',
    'website': 'http://partners.sanjosemayor.org/servesj',
    'email': 'ario.lab18@gmail.com',
  },
  {
    'name': 'Civil Air Patrol',
    'info': ['aerospace', 'space', 'stem', 'science', 'camps'],
    'address': '105 S. Hansell Street, Maxwell AFB, AL 36112',
    'website': 'https://www.gocivilairpatrol.com/',
    'email': 'kaylin.pham@cawgcap.org',
  },
  {
    'name': 'Adopt a Park',
    'info': [],
    'address': '',
    'website': 'http://partners.sanjosemayor.org/servesj',
    'email': 'Adopt-A-Park@sanjoseca.gov',
  },
  {
    'name': 'All Animal Rescue and Friends',
    'info': ['animal', 'nature'],
    'address': 'San Martin, CA 95046',
    'website': 'http://AARFlove.org',
    'email': 'info@AARFlove.org',
  },
  {
    'name': 'Animal Assisted Happiness',
    'info': ['animal', 'youth', 'mental health'],
    'address': 'Baylands Park, 999 E Caribbean Dr, Sunnyvale, CA 94089',
    'website': 'http://animalassistedhappiness.org',
    'email': 'erica@aahsmilefarm.org',
  },
  {
    'name': 'Cal Color Academy - Fremont',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '47816 Warm Springs Blvd, Fremont, CA 94539',
    'website': 'http://calcolor.com',
    'email': 'iesha@calcolor.com',
  },
  {
    'name': 'Cal Color Academy - Cupertino',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '10626 S De Anza Blvd, Cupertino, CA 95014',
    'website': 'http://calcolor.com',
    'email': 'iesha@calcolor.com',
  },
  {
    'name': 'Cal Color Academy - Mountain View',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '612 San Antonio Rd, Mountain View, CA 94040',
    'website': 'http://calcolor.com',
    'email': 'iesha@calcolor.com',
  },
  {
    'name': 'Cal Color Academy - San Jose',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '1711 Branham Ln, Ste 20, San Jose, CA 95118',
    'website': 'http://calcolor.com',
    'email': 'iesha@calcolor.com',
  },
  {
    'name': 'Cal Color Academy - Newark',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '35467 Dumbarton Ct, Newark, CA 94560',
    'website': 'http://calcolor.com',
    'email': 'iesha@calcolor.com',
  },
  {
    'name': 'Bay Area Glass Institute',
    'info': ['art', 'creative', 'glass blowing'],
    'address': '635 Phelan Ave., San Jose, CA 95112',
    'website': 'http://www.bagi.org',
    'email': 'studio@bagi.org',
  },
  {
    'name': 'Montalvo Art Center',
    'info': ['art', 'cultural', 'creative'],
    'address': '15400 Montalvo Rd., Saratoga, CA 95071',
    'website': 'http://montalvoarts.org',
    'email': 'KMcQuade@montalvoarts.org',
  },
  {
    'name': 'Youth Art Foundation',
    'info': ['art', 'leadership', 'training', 'educaiton', 'youth'],
    'address': '',
    'website': 'http://youthart.org',
    'email': 'cheryl@youthart.org',
  },
  {
    'name': 'Hype Baseball',
    'info': ['athletics', 'sports', 'baseball'],
    'address': '',
    'website': 'http://hypebaseball.com',
    'email': 'c_enriquez@comcast.net',
  },
  {
    'name': 'Luv Michael',
    'info': ['autism', 'community', 'service', 'health'],
    'address': '42 Walker Street, New York, NY 10013',
    'website': 'https://luvmichael.com',
    'email': 'dchudley@luvmichael.com',
  },
  {
    'name': 'Hiller Aviation Museum',
    'info': ['aviation', 'museum', 'education'],
    'address': '601 Skyway Rd., San Carlos, CA 94070',
    'website': 'http://hiller.org',
    'email': 'tanya@hiller.org',
  },
  {
    'name': 'Home Equity Plus',
    'info': ['awareness', 'health', 'equity', 'community'],
    'address': '',
    'website': 'http://healthequityplus.net',
    'email': 'healthequityplus@gmail.com',
  },
  {
    'name': 'Santa Theresa Little League',
    'info': ['baseball', 'athletics', 'sports'],
    'address': 'San Jose, California 95153',
    'website': 'https://www.stlittleleague.org/',
    'email': 'vice_president@stlittleleague.org',
  },
  {
    'name': 'Cencal Athletics',
    'info': ['baseball', 'athletics', 'sports', 'children', 'kids'],
    'address': '1005 E Pescadero Ave, Tracy, CA 95304',
    'website': 'http://cencalathletics.com',
    'email': 'Cencalathletics.thauberger@gmail.com',
  },
  {
    'name': 'Save Our Shores',
    'info': [
      'beach',
      'cleanup',
      'shores',
      'nature',
      'outdoors',
      'sealife',
      'ocean'
    ],
    'address': '345 Lake Ave., Suite A, Santa Cruz, CA 95062',
    'website': 'http://saveourshores.org',
    'email': 'peter@saveourshores.org',
  },
  {
    'name': 'Silicon Valley Bicycle Exchange',
    'info': ['bicycle', 'repairs', 'community', 'service'],
    'address': '3961 East Bayshore Road, Palo Alto, CA 94303',
    'website': 'http://bikex.org',
    'email': 'gsteinbach@gmail.com',
  },
  {
    'name': 'Community Cycles of California',
    'info': ['bike', 'cycle', 'bicycle', 'economic', 'community'],
    'address': '35 Wilson Ave., San Jose, CA 95126',
    'website': 'http://communitycyclesca.org',
    'email': 'Cindy@communitycyclesca.org',
  },
  {
    'name': 'Boys and Girls Clubs of Silicon Valley',
    'info': ['boys', 'girls', 'youth', 'children', 'sports', 'education'],
    'address': '518 Valley Way, Milpitas, CA 95035',
    'website': 'http://bgclub.org',
    'email': 'brenda.otero@bgclub.org',
  },
  {
    'name': 'YMCA Camp Campbell',
    'info': ['camp', 'athletics', 'youth', 'student', 'sports'],
    'address': '',
    'website': 'http://ymcasv.com',
    'email': 'Eric.Weiss@ymcasv.org',
  },
  {
    'name': 'Pioneer Camp',
    'info': ['camp', 'children', 'summer'],
    'address': '942 Clearwater Lake Road, Port Sydney, Ontario P0B 1L0',
    'website': 'http://pioneercampontario.ca',
    'email': 'kbeaven@pioneercamp.ca',
  },
  {
    'name': 'The Kings Academy Summer Camp',
    'info': ['camp', 'education', 'summer', 'tutoring'],
    'address': '562 N. Britton Avenue, Sunnyvale, CA 94085',
    'website': 'https://www.tka.org/cf_enotify/view.cfm?n=7751',
    'email': 'annette.lane@tka.org',
  },
  {
    'name': 'Camp Thrive',
    'info': ['camps', 'education', 'creative', 'kids', 'children'],
    'address': 'Mount Hermon, CA 95041',
    'website': 'http://campthrive.org',
    'email': 'aidan@campthrive.org',
  },
  {
    'name': 'Youth Science Institute',
    'info': ['camps', 'science', 'youth', 'education', 'summer', 'learning'],
    'address': '333 Blossom Hill Road, Los Gatos, CA 95032',
    'website': 'http://ysi-ca.com',
    'email': 'cassie@ysi-ca.org',
  },
  {
    'name': 'Leukemia and Lymphoma Society',
    'info': ['cancer', 'health', 'support', 'science', 'hospital'],
    'address': '3 International Drive, Suite 200, Rye Brook, NY 10573',
    'website': 'http://lls.org',
    'email': 'Claire.Bang@lls.org',
  },
  {
    'name': 'Mini Cat Town',
    'info': ['cat', 'adoption', 'rescue', 'animals', 'animal'],
    'address': '2200 Eastridge Loop, STE 1076, San Jose, CA 95122',
    'website': 'http://minicattown.org',
    'email': 'minicattown@gmail.com',
  },
  {
    'name': 'St. Victor\'s School',
    'info': ['catholic', 'school', 'education', 'student', 'teacher'],
    'address': '3150 Sierra Road, San Jose, CA  95132',
    'website': 'http://stvictorschool.org',
    'email': 'ncalabio@stvictor.org',
  },
  {
    'name': 'Walden West',
    'info': [
      'children',
      'education',
      'camps',
      'athletics',
      'outdoors',
      'adventure'
    ],
    'address': '15555 Sanborn Rd., Saratoga, CA 95070',
    'website': 'http://waldenwest.org',
    'email': 'Leigh_Jones@sccoe.org',
  },
  {
    'name': 'Bridge Road International Foundation',
    'info': ['chinese', 'cultural', 'education'],
    'address': '2090 Warm Springs Ct. Suit 256, Fremont, CA, 94539',
    'website': 'https://info889978.wixsite.com/bribri',
    'email': 'yhr@bridgeroadinternational.org',
  },
  {
    'name': 'Chinese History Museum',
    'info': ['chinese', 'cultural', 'education', 'museum'],
    'address': '635 Phelan Avenue, San Jose, CA 95112',
    'website': 'http://chcp.org',
    'email': 'brenda.wong@chcp.org',
  },
  {
    'name': 'Boys Team Charity',
    'info': [],
    'address': '',
    'website': 'http://btcalmaden.chapterweb.net',
    'email': 'president@btcalmadenvalley.org',
  },
  {
    'name': 'The Joy Culture Foundation',
    'info': ['chinese', 'culture', 'language', 'children'],
    'address': '934 Santa Cruz Ave Suite A, Menlo Park, CA 94025',
    'website': 'https://www.thejoyculturefoundation.org/',
    'email': 'patty.cheng@thejoyculturefoundation.org',
  },
  {
    'name': 'Enlighten Chinese School',
    'info': ['chinese', 'language', 'tutor', 'education'],
    'address': '1921 Clarinda Way, San Jose, CA 95124',
    'website': 'http://enlightenschool.org',
    'email': 'wtang@enlightenchinese.org',
  },
  {
    'name': 'IFly',
    'info': ['chinese', 'learning', 'education'],
    'address': '',
    'website': 'http://iflyyoung.com',
    'email': 'selena.shan@iflyyoung.org',
  },
  {
    'name': 'Family Giving Tree',
    'info': ['christmas', 'community', 'festival', 'poverty'],
    'address':
        'Family Giving Tree, Sobrato Center for Nonprofits, 606 Valley Way, Milpitas CA 95035',
    'website': 'http://familygivingtree.org',
    'email': 'jazmin@familygivingtree.org',
  },
  {
    'name': 'Bit By Bit Coding',
    'info': ['code', 'education', 'children', 'under represented', 'students'],
    'address': '',
    'website': 'http://bitbybitcoding.org',
    'email': 'anushka@bitbybitcoding.org',
  },
  {
    'name': 'Code For Fun',
    'info': [
      'code',
      'education',
      'stem',
      'science',
      'student',
      'kids',
      'childrent'
    ],
    'address': '1111 West El Camino Real, Suite 211, Sunnyvale, CA 94087',
    'website': 'http://codeforfun.com',
    'email': 'ujjwala@codeforfun.com',
  },
  {
    'name': 'Code For San Jose',
    'info': [
      'code',
      'education',
      'stem',
      'science',
      'student',
      'kids',
      'childrent'
    ],
    'address': '453 W San Carlos St, San José, CA 95110',
    'website': 'http://codeforsanjose.org',
    'email': 'enguyen6208@gmail.com',
  },
  {
    'name': 'Morgan Hill Chamber of Commerce',
    'info': [
      'commerce',
      'business',
      'enterpreneurship',
      'leadership',
      'chamber'
    ],
    'address': '17500 Depot St., Ste. 260, Morgan Hill, CA 95037',
    'website': 'http://morganhillchamber.org',
    'email': 'brooke@morganhillchamber.org',
  },
  {
    'name': 'City of San Jose',
    'info': ['community'],
    'address': '',
    'website': '',
    'email': 'irma.montes@sanjoseca.gov',
  },
  {
    'name': 'City of Saratoga',
    'info': ['community'],
    'address': '',
    'website': 'http://saratoga.ca.us/278/Volunteer',
    'email': 'hr@saratoga.ca.us',
  },
  {
    'name': 'JW House',
    'info': ['community', 'hospitality', 'service', 'health', 'support'],
    'address': '3850 Homestead Road, Santa Clara, CA 95051',
    'website': 'http://jwhouse.org',
    'email': 'Nayna@jwhouse.org',
  },
  {
    'name': 'Freedom Fest',
    'info': ['community', 'service'],
    'address': 'Morgan Hill, CA 95038',
    'website': 'https://morganhillfreedomfest.com/volunteer',
    'email': 'mdstein@gmail.com',
  },
  {
    'name': 'Grace Solutions',
    'info': ['community', 'service'],
    'address': '484 E. San Fernando St., San Jose, Ca. 95112',
    'website': 'https://www.gracesolutions.org/',
    'email': 'rams1942@icloud.com',
  },
  {
    'name': 'Saratoga Library',
    'info': ['community', 'service'],
    'address': '13650 Saratoga Ave, Saratoga, CA 95070',
    'website': 'http://sccl.org',
    'email': 'BSpring@sccl.org',
  },
  {
    'name': 'Youth Action Council Morgan Hill',
    'info': ['community', 'service'],
    'address': '17575 Peak Avenue, Morgan Hill, CA 95037',
    'website': 'http://morgan-hill.ca.gov/273/Youth-Action-Council',
    'email': 'chiquy.mejia@mhcrc.org',
  },
  {
    'name': 'Love To Share Foundation',
    'info': ['community', 'service', 'care'],
    'address': '3363 Bel Mira Way, San Jose, CA 95135',
    'website': 'https://lovetosharefoundation.org/',
    'email': 'admin@lovetosharefoundation.org',
  },
  {
    'name': 'House of Hope',
    'info': [
      'community',
      'service',
      'church',
      'food',
      'spiritual',
      'emotional'
    ],
    'address': '16330 Los Gatos Blvd., Los Gatos, Ca. 95032',
    'website': 'https://www.calvarylg.com/houseofhope',
    'email': 'jwinters@calvarylg.com',
  },
  {
    'name': 'Los Gatos Recreation',
    'info': [
      'community',
      'service',
      'enrichment',
      'education',
      'camps',
      'recreation'
    ],
    'address': '123 E Main St, Los Gatos, CA 95030',
    'website': 'https://www.lgsrecreation.org/',
    'email': 'kmoultrup@lgsrecreation',
  },
  {
    'name': 'Youth Leadership Coalition District 10',
    'info': ['community', 'service', 'government', 'youth'],
    'address': '',
    'website': 'http://d10advisorycouncil.wixsite.com/district10yac',
    'email': 'alexander.lee2023@gmail.com',
  },
  {
    'name': 'Youth Leadership Coalition District 5',
    'info': ['community', 'service', 'government', 'youth'],
    'address': '200 E. Santa Clara St., San Jose, Ca 95113',
    'website':
        'https://www.sanjoseca.gov/your-government/departments-offices/mayor-and-city-council/district-5/meet-the-d5-team',
    'email': 'youthcom5@sanjoseca.gove',
  },
  {
    'name': 'STAND 4 Inc.',
    'info': ['community', 'service', 'injustice', 'youth', 'teens'],
    'address': '',
    'website': 'http://fightthehateglobal.org',
    'email': 'janet.abbey@yahoo.co.uk',
  },
  {
    'name': 'Hope Horizon',
    'info': ['community', 'service', 'leadership'],
    'address': '1001 Beech St, East Palo Alto, CA 94303',
    'website': 'http://hopehorizonepa.org',
    'email': 'amy@hopehorizonepa.org',
  },
  {
    'name': 'LOV League of Volunteers',
    'info': ['community', 'service', 'poverty', 'kids', 'food'],
    'address': 'Newark, CA 94560',
    'website': 'http://lov.org',
    'email': 'Sharon@lov.org',
  },
  {
    'name': 'Bill Wilson Center',
    'info': ['counseling', 'housing', 'education', 'advocacy.'],
    'address': '3490 The Alameda, Santa Clara, CA 95050',
    'website': 'http://billwilsoncenter.org',
    'email': 'csanchez@billwilsoncenter.org',
  },
  {
    'name': 'Color A Smile',
    'info': [],
    'address': '',
    'website': 'http://colorasmile.org',
    'email': 'info@colorasmile.org',
  },
  {
    'name': 'South Bay Clean Creeks Coalition',
    'info': ['creeks', 'river', 'nature', 'outdoors', 'cleanup'],
    'address': '',
    'website': 'https://sbcleancreeks.com/',
    'email': 'info@sbcleancreeks.com',
  },
  {
    'name': 'Mosaic America',
    'info': ['culture', 'community', 'service', 'local', 'arts'],
    'address': '',
    'website': 'http://mosaicamerica.org',
    'email': 'usha@mosaicamerica.org',
  },
  {
    'name': 'San Jose Dance Theater',
    'info': ['dance', 'culture', 'arts', 'theater'],
    'address': '1756 Junction Ave. Suite E, San Jose, CA 95112',
    'website': 'http://Sjdt.org',
    'email': 'jessie@sjdt.org',
  },
  {
    'name': 'Best Buddies',
    'info': ['disabilities', 'children', 'youth'],
    'address': '100 Southeast Second St, Suite 2200, Miami, FL 33131',
    'website': 'http://bestbuddies.org',
    'email': 'MelissaCagney@bestbuddies.org',
  },
  {
    'name': 'Artistic Swimming for Athletes with Disabilities',
    'info': ['disability', 'swimming', 'athletics', 'sports'],
    'address': '1484 Pollard Rd #221, Los Gatos, CA 95032',
    'website': 'https://www.artisticswimawd.org',
    'email': 'bayareasynchro@gmail.com',
  },
  {
    'name': 'Doggie Protective Services (DPS)',
    'info': ['dog', 'adoption', 'rescue', 'animal'],
    'address': '809 San Antonio Rd #8, Palo Alto, CA 94303',
    'website': 'https://dpsrescue.org/',
    'email': 'volunteer@dpsrescue.org',
  },
  {
    'name': 'Jake\'s Wish Rescue',
    'info': ['dog', 'adoption', 'rescue', 'animal'],
    'address': 'San Martin, CA 95046',
    'website': 'http://jakeswishrescue.org',
    'email': 'jens@jakeswishrescue.org',
  },
  {
    'name': 'Next Door Solutions To Domestic Violence',
    'info': [
      'domestic violence',
      'violence',
      'adults',
      'community',
      'mental support'
    ],
    'address': '234 E. Gish Road, Suite 200, San Jose, CA 95112',
    'website': 'http://nextdoor.org',
    'email': 'bwilliams@nextdoor.org',
  },
  {
    'name': 'Almaden Country Day School',
    'info': ['education'],
    'address': '6835 Trinidad Drive, San Jose, CA 95120',
    'website': 'http://almadencountrydayschool.org/',
    'email': 'qsong@almadencountryday.org',
  },
  {
    'name': 'Hacienda Elementary',
    'info': ['education', 'children', 'kids', 'students'],
    'address':
        'Hacienda Science/Environmental Magnet, 1290 Kimberly Drive, San Jose, CA 95118',
    'website': 'http://hacienda.sjusd.org',
    'email': 'tweber@sjusd.org',
  },
  {
    'name': 'Shin Shin Educational Foundation',
    'info': ['education', 'china', 'chinese', 'children', 'kids'],
    'address': '',
    'website': 'http://shinshinfoundation.org',
    'email': 'aibin.chen@shinshinfoundation.org',
  },
  {
    'name': 'Leland Bridge at Leland High School',
    'info': ['education', 'chinese'],
    'address': '',
    'website': 'https://www.lelandbridge.org/',
    'email': 'vp@lealandbridge.org',
  },
  {
    'name': 'Wisdom Culture Education Organization',
    'info': ['education', 'chinese', 'culture', 'youth'],
    'address': '186 E. Gish Rd., San Jose, CA 95112',
    'website': 'http://wceo.org',
    'email': 'jasmine@wceo.org',
  },
  {
    'name': 'American Chinese School',
    'info': ['education', 'chinese', 'language'],
    'address': '5259 Amberwood Dr, Fremont, CA 94555',
    'website': 'http://achineseschool.org',
    'email': 'adahuang@achineseschool.org',
  },
  {
    'name': 'Neighborhood Christian Schools',
    'info': ['education', 'christian', 'students', 'kids', 'children'],
    'address': '16010 Jackson Oaks Dr, Morgan Hill, CA 95037',
    'website': 'http://myncs.net',
    'email': 'rdaughertyk@myncs.net',
  },
  {
    'name': 'Sparkhub Foundation',
    'info': ['education', 'community', 'service'],
    'address': '',
    'website': 'http://sparkhubfoundation.org',
    'email': 'jenny94539@gmail.com',
  },
  {
    'name': 'Meaningful Teens Program (Project Speak Together)',
    'info': ['education', 'language', 'math', 'students'],
    'address': '',
    'website': 'https://projectspeaktogether.com/',
    'email': 'projectspeaktogether@gmail.com',
  },
  {
    'name': 'San Jose Parent Participating Preschool',
    'info': ['education', 'parents', 'school', 'preschool'],
    'address': '2180 Radio Ave, San Jose, CA 95125',
    'website': 'http://sanjoseparents.org',
    'email': 'jessimica727@gmail.com',
  },
  {
    'name': 'Almaden Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '1295 Dentwood Dr, San Jose, CA 95118',
    'website': 'http://almaden.sjusd.org',
    'email': 'ktorrez@sjusd.org',
  },
  {
    'name': 'Hellyer Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '725 Hellyer Avenue, San Jose, CA 95111',
    'website': 'http://hellyer.fmsd.org',
    'email': 'jose.jacinto@fmsd.org',
  },
  {
    'name': 'James Franklin Smith Elementary',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '2220 Woodbury Ln., San JoseCA95121',
    'website': 'http://jfsmith.eesd.org',
    'email': 'Alara@eesd.org',
  },
  {
    'name': 'Lietz Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '5300 CARTER AVENUE, SAN JOSE, CA 95118',
    'website': 'http://lietz.unionsd.org',
    'email': 'Lacyr@unionsd.org',
  },
  {
    'name': 'Los Alimitos Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '6130 Silberman Drive, San Jose, CA 95120',
    'website': 'http://losalamitos.sjusd.org',
    'email': 'allison.stephanian@gmail.com',
  },
  {
    'name': 'Oak Ridge Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '5920 Bufkin Dr, San Jose, CA 95123',
    'website': 'http://oakridge.ogsd.net',
    'email': 'achang137@gmail.com',
  },
  {
    'name': 'Ramblewood Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '1351 Lightland Road, San Jose, CA 95121',
    'website': 'http://ramblewood.fmsd.org',
    'email': 'victoria.fernandez@fmsd.org',
  },
  {
    'name': 'Silver Oak Elementary',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '5000 Farnsworth Dr, San Jose, CA 95138',
    'website': 'http://soepto.ptboard.com',
    'email': 'nicolinag@gmail.com',
  },
  {
    'name': 'St. Clare School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '750 WASHINGTON STREET, SANTA CLARA, CA 95050',
    'website': 'http://stclare.school/after-school-care',
    'email': 'valerye.moore@dsj.org',
  },
  {
    'name': 'Williams Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '1150 Rajkovich Way, San Jose, CA 95120',
    'website': 'http://williams.sjusd.org',
    'email': 'Lauralimasa@gmail.com',
  },
  {
    'name': 'Windmill Springs Elementary School',
    'info': [
      'education',
      'school',
      'kids',
      'children',
      'students',
      'tutoring',
      'mentoring'
    ],
    'address': '2880 Aetna Way, San Jose, CA 95121',
    'website': 'http://windmillsprings.fmsd.org',
    'email': 'becky.roussin@fmsd.org',
  },
  {
    'name': 'Los Gatos Christian School',
    'info': ['education', 'school', 'students'],
    'address': '16845 Hicks Road, Los Gatos, California 95032',
    'website': 'http://lgcs.org',
    'email': 'info@lgcs.org',
  },
  {
    'name': 'Charter School of Morgan Hill',
    'info': ['education', 'school', 'students', 'kids'],
    'address': '9530 Monterey Rd., Morgan Hill, CA 95037',
    'website': 'http://csmh.org',
    'email': 'ndepalma@csmh.org',
  },
  {
    'name': 'Green Scholars Program',
    'info': [],
    'address': '',
    'website': 'http://greenescholars.org',
    'email': 'contact@greenscholars.org',
  },
  {
    'name': 'AiducateNow',
    'info': ['education', 'stem', 'india'],
    'address': '',
    'website': 'http://aiducatenow.org',
    'email': 'aiducatenow@gmail.com',
  },
  {
    'name': 'Sillicon Valley Youth',
    'info': ['education', 'students', 'youth', 'underpreveliged'],
    'address': '',
    'website': 'https://www.siliconvalleyyouth.com',
    'email': 'svyouth1@gmail.com',
  },
  {
    'name': 'Bay Area Tutors',
    'info': ['education', 'tutor', 'children', 'students'],
    'address': '',
    'website': 'http://bayareatutor.org',
    'email': 'best@bayareatutor.org',
  },
  {
    'name': 'Breakthrough Tutoring Silicon Valley',
    'info': ['education', 'tutor', 'children', 'students', 'low-income'],
    'address': '1635 PARK AVE #138, SAN JOSE, CA 95126',
    'website': 'http://www.breakthroughsv.org',
    'email': 'tutoring@breakthroughsv.org',
  },
  {
    'name': 'Catepillar Academy',
    'info': ['education', 'tutor', 'students', 'kids'],
    'address': '',
    'website': 'http://caterpillaracademy.org',
    'email': 'catenglishacademy@gmail.com',
  },
  {
    'name': 'Happy Hollow (City of San Jose)',
    'info': [],
    'address': '',
    'website': 'http://happyhollow.org',
    'email': 'hhpzeducation@sanjoseca.gov',
  },
  {
    'name': 'Evergreen Initiative',
    'info': ['education', 'tutor', 'students', 'kids'],
    'address': '',
    'website': 'http://evergreeninitiative.weebly.com',
    'email': 'aiden.bergey@warroiorlife.et',
  },
  {
    'name': 'Gyandeep Growth Foundation',
    'info': ['education', 'under previleged', 'children'],
    'address': '',
    'website': '',
    'email': 'gyandeepgpx@gmail.com',
  },
  {
    'name': 'Paradise Engineering Academy',
    'info': ['engineering', 'science', 'stem', 'students', 'education'],
    'address': '1400 La Crosse Dr., Morgan Hill, CA 95037',
    'website': 'http://paradise.mhusd.org',
    'email': 'Wheatley@mhusd.com',
  },
  {
    'name': 'Pacific E-Sports League',
    'info': ['esports', 'gaming', 'videogames'],
    'address': '',
    'website': 'http://pacificesports.org',
    'email': 'matthew@pacificesports.org',
  },
  {
    'name': 'Center For Farmworker Families',
    'info': ['farming', 'mexico', 'support'],
    'address': 'Felton, CA 95018',
    'website': 'http://farmworkerfamily.org',
    'email': 'ann@farmworkerfamily.org',
  },
  {
    'name': 'Octavia\'s Kitchen',
    'info': ['food', 'community', 'service', 'kitchen'],
    'address': 'St James Park, San Jose, CA 95112',
    'website': 'http://octaviaskitchen.org',
    'email': 'info@octaviaskitchen.org',
  },
  {
    'name': 'La Mesa Verde',
    'info': ['food', 'health', 'community', 'service', 'gardening'],
    'address': '1381 S First St, San Jose, CA 95110',
    'website': 'https://www.lamesaverdeshcs.org/',
    'email': 'Fernandof@sacredheartcs.org',
  },
  {
    'name': 'Hope Hearted Volunteers',
    'info': ['food', 'homeless', 'low income'],
    'address': '',
    'website': 'http://hopeheartedvolunteers.org',
    'email': 'chloe@valencevibrations.com',
  },
  {
    'name': 'Street Life Ministries',
    'info': ['food', 'homeless', 'shelter', 'community', 'service'],
    'address': '2890 Middlefield Road, Palo Alto, CA 94306',
    'website': 'http://streetlifeministries.org',
    'email': 'ricky@streetlifeministries.org',
  },
  {
    'name': 'Second Harvest Food Bank',
    'info': ['food', 'homelessness', 'poor', 'community', 'service'],
    'address': '750 Curtner Avenue, San Jose, CA 95125',
    'website': 'http://shfb.org',
    'email': 'jbrambila@shfb.org',
  },
  {
    'name': 'Hongyun Art Foundation',
    'info': [],
    'address': '',
    'website': 'http://hyafound.org',
    'email': 'inbox@hongyunart.com',
  },
  {
    'name': 'Martha\'s Kitchen',
    'info': ['food', 'poverty', 'homeless', 'community', 'service'],
    'address': '311 Willow St, San Jose, CA 95110',
    'website': 'http://marthas-kitchen.org',
    'email': 'jennie@marthas-kitchen.org',
  },
  {
    'name': 'Loaves and Fishes',
    'info': [
      'food',
      'poverty',
      'homeless',
      'community',
      'service',
      'meals on wheels'
    ],
    'address': '648 GRIFFITH ROAD, SUITE B, CHARLOTTE, NC 28217',
    'website': 'http://loavesandfishes.org',
    'email': 'volunteer@loavesfishes.org',
  },
  {
    'name': 'Pop Warner League',
    'info': ['football', 'cheerleading', 'sports', 'athletics'],
    'address': '16500 Condit Road, Morgan Hill , CA 95037',
    'website': 'http://morganhillraiders.com',
    'email': 'Coachdmhr@gmail.com',
  },
  {
    'name': 'Football Camp for the Stars',
    'info': [
      'football',
      'disability',
      'speical needs',
      'downs syndrome',
      'health'
    ],
    'address': '100 Skyway Dr., San Jose CA, 95111',
    'website': 'http://footballcampforthestars.com',
    'email': 'mmachado@vcs.net',
  },
  {
    'name': 'Francaise Silicon Valley',
    'info': ['french', 'language', 'education', 'classes'],
    'address': '14107 Winchester Blvd, Suite T, Los Gatos, CA 95032',
    'website': 'http://www.afscv.org',
    'email': 'virginie.zenero@afscv.org',
  },
  {
    'name': 'Taylor Street Farms',
    'info': ['garden', 'farm', 'outdoors', 'nature', 'food'],
    'address': '200 W Taylor St. San Jose, CA 95110',
    'website': 'http://garden2tablesv.org',
    'email': 'team@garden2tablesv.org',
  },
  {
    'name': 'Heritage Rose Garden at Guadalupe Park',
    'info': ['gardening', 'nature', 'plant'],
    'address': '438 Coleman Ave, San Jose, CA 95110',
    'website': 'http://heritageroses.us',
    'email': 'gillian@grpg.com',
  },
  {
    'name': 'Indian Health Center of Santa Clara Valley',
    'info': [],
    'address': '',
    'website': 'http://indianhealthcenter.org',
    'email': 'vmcloud@ihcscv.org',
  },
  {
    'name': 'Girls On The Run',
    'info': ['girls', 'children', 'sports', 'athletics'],
    'address': 'LOS GATOS, CA 95031',
    'website': 'http://gotrsv.org',
    'email': 'carol@gotrsv.org',
  },
  {
    'name': 'Foundation-US Kids Golf',
    'info': ['golf', 'atheltics', 'sports'],
    'address': '',
    'website': 'https://www.uskidsgolf.com/',
    'email': 'cvuskg@gmail.com',
  },
  {
    'name': 'First Tea of Sillicon Valley',
    'info': ['golf', 'low income', 'sports', 'atheltics'],
    'address': '2797 Park Avenue , Suite 205, Santa Clara, CA, 95050',
    'website': 'http://firstteesiliconvalley.org/about/volunteer',
    'email': 'julie@ftsv.org',
  },
  {
    'name': 'Peninsula Guitar Series',
    'info': ['guitar', 'classical music', 'performance', 'cultural', 'arts'],
    'address': '',
    'website': 'http://peninsulaguitar.com',
    'email': 'Rmiller2ster@gmail.com',
  },
  {
    'name': 'Onehacks',
    'info': ['hackathon', 'coding', 'stem', 'science', 'code', 'youth'],
    'address': '',
    'website': 'http://onehacks.org',
    'email': 'info@onehacks.org',
  },
  {
    'name': 'San Francisco Calheat Team Handball Club',
    'info': ['handball', 'sports', 'athletics'],
    'address': '',
    'website': 'http://calheat.com',
    'email': 'bernward68@gmail.com',
  },
  {
    'name': 'Kaiser Permanente',
    'info': [],
    'address': '',
    'website': 'http://kp.org',
    'email': 'volunteer-ncal.kaiserpermanente.org',
  },
  {
    'name': 'Cure A Little Heart Foundation',
    'info': ['health', 'children', 'medical'],
    'address': '4779 S, 7th Street, Terre Haute, IN 47802',
    'website': 'http://hrudaya.org',
    'email': 'jvejendla@gmail.com',
  },
  {
    'name': 'Coach Art',
    'info': ['health', 'coach', 'mentor', 'art', 'creative', 'student', 'kids'],
    'address': '445 S. Figueroa St. Suite 3100, Los Angeles, CA 90071',
    'website': 'http://coachart.org',
    'email': 'erick@coachart.org',
  },
  {
    'name': 'Health Trust',
    'info': ['health', 'community', 'service'],
    'address': '3180 Newberry Dr., Suite 200, San Jose, CA 95118',
    'website': 'http://healthtrust.org/volunteer',
    'email': 'mayraC@healthtrust.org',
  },
  {
    'name': 'Walk For Life WC',
    'info': ['health', 'community', 'service'],
    'address': 'San Francisco, CA  94122',
    'website': 'https://www.walkforlifewc.com',
    'email': 'RWRoller@comcast.net',
  },
  {
    'name': 'Breathe California of the Bay Area',
    'info': ['health', 'diseases', 'illness'],
    'address': '1469 Park Avenue, San Jose, CA 95126',
    'website': 'https://lungsrus.org',
    'email': 'margo@lungsrus.org',
  },
  {
    'name': 'Africa Cries Out',
    'info': ['health', 'education'],
    'address': '1171 East Putnam Ave, Riverside, CT 06878 USA',
    'website': 'http://africacriesout.net',
    'email': 'dr.baoli@email.com',
  },
  {
    'name': 'Healing Grove Medical Center',
    'info': ['health', 'healthcare', 'medical'],
    'address': '226 W. Alma Ave, Suite 10, San Jose, CA 95110',
    'website': 'https://healinggrove.org',
    'email': 'bret@healinggrove.org',
  },
  {
    'name': 'Healthier Kids Foundation',
    'info': ['health', 'kids', 'community', 'service'],
    'address': '4040 Moorpark Ave, Suite 100, San Jose, CA 95117',
    'website': 'http://hkidsf.org',
    'email': 'kathleen@hkidsf.org',
  },
  {
    'name': 'American Foundation for Suicide Prevention',
    'info': ['health', 'mental health', 'suicide', 'emotional health'],
    'address': '2635 Napa St #3557, Vallejo, CA 94590',
    'website': 'http://afsp.org',
    'email': 'artmankim6@gmail.com',
  },
  {
    'name': 'Pragnya',
    'info': ['health', 'neuro', 'special needs', 'diversity', 'children'],
    'address': '1917 Concourse Drv, San Jose, CA 95131',
    'website': 'https://www.pragnya.org',
    'email': 'Kavita@pragnya.org',
  },
  {
    'name': 'Real Options',
    'info': ['healthcare', 'health', 'community', 'hospital', 'clinic'],
    'address': '1671 The Alameda, Suite 101, San Jose, CA 95126',
    'website': 'http://friendsofrealoptions.net',
    'email': 'tina@realoptions.net',
  },
  {
    'name': 'US Department of Veteran Affairs',
    'info': ['healthcare', 'hospital', 'clinic', 'veteran'],
    'address': '795 Willow Road, Menlo Park, CA 94025',
    'website': 'http://va.gov/palo-alto-health-care',
    'email': 'evan.fasbinder@va.gov',
  },
  {
    'name': 'Tri Valley Hockey Association Inc.',
    'info': ['hockey', 'sports', 'athletics'],
    'address': 'Dublin, CA 94568',
    'website': 'http://trivalleyminorhockey.com',
    'email': 'mike.holmes@comcast.net',
  },
  {
    'name': 'Habitat for Humanity Bay Area',
    'info': ['home', 'community', 'construction', 'service'],
    'address': '513 Valley Way, Milpitas, CA 95035',
    'website': 'http://habitatebsv.org',
    'email': 'EAlaimo@habitatebsv.org',
  },
  {
    'name': 'Agape Silicon Valley',
    'info': ['homeless', 'hunger'],
    'address': '',
    'website': 'http://agapesiliconvalley.org',
    'email': 'agapesiliconvalley@gmail.com',
  },
  {
    'name': 'Seva Commons Foundation',
    'info': ['homelessness', 'food', 'hungry', 'community', 'service'],
    'address': '',
    'website': 'http://sevacommons.org',
    'email': 'anupamanarahari@gmail.com',
  },
  {
    'name': 'Help4Hope',
    'info': ['homelessness', 'food', 'poor', 'health'],
    'address': '',
    'website': 'http://help4hope.godaddysites.com',
    'email': 'khanhha_le@yahoo.com',
  },
  {
    'name': 'Sleeping Bags for Homeless',
    'info': ['homelessness', 'poverty', 'community', 'service'],
    'address': '',
    'website': '',
    'email': 'garcia.hector11@gmail.com',
  },
  {
    'name': 'Head Heart and Hands',
    'info': ['homeschooling', 'education', 'kids', 'children', 'students'],
    'address': '',
    'website': 'https://www.head-heart-hands.org/',
    'email': 'sjosselyn@vcs.net',
  },
  {
    'name': 'Divine Equestrian Therapy',
    'info': ['horse', 'riding'],
    'address': '',
    'website': 'http://divineequinetherapy.org',
    'email': 'kristy@divineequinetherapy.org',
  },
  {
    'name': 'Cevalo Riding Academy',
    'info': ['horse', 'riding', 'kids', 'animals', 'students'],
    'address': 'Los Gatos, CA 95032',
    'website': 'https://www.cevaloridingacademy.org/',
    'email': 'horses3d@gmail.com',
  },
  {
    'name': 'Dream Power',
    'info': ['horse', 'riding', 'therapy', 'health'],
    'address': '4478 GA-352, Box Springs, GA 31801',
    'website': 'https://dreampowertherapy.org/',
    'email': 'martha@dreampowerhorsemanship.com',
  },
  {
    'name': 'El Camino Hospital',
    'info': ['hospital', 'medicine', 'health'],
    'address':
        'El Camino Health, Auxiliary & Volunteer Services, Willow Pavilion, 2nd Floor, 2500 Grant Road, Mountain View, CA 94040',
    'website': 'http://elcaminohealth.org/volunteer/auxiliary',
    'email': 'Vanessa_Binder@elcaminohealtha.org',
  },
  {
    'name': 'Morgan Hill Historical Society',
    'info': [],
    'address': '',
    'website': 'http://morganhillhistoricalsociety.org',
    'email': 'info@morganhillhistoricalsociety.com',
  },
  {
    'name': 'Live Moves',
    'info': ['housing', 'poverty', 'homeless', 'community', 'service'],
    'address': '2550 Great America Way, Suite 201, Santa Clara, CA 95054',
    'website': 'http://lifemoves.org',
    'email': 'lbilsey@lifemoves.org',
  },
  {
    'name': 'Hunger At Home',
    'info': ['hunger', 'food', 'low income', 'community', 'service'],
    'address': '1560 Berger Drive, San Jose, CA 95112',
    'website': 'http://hungerathome.org',
    'email': 'volunteer@hungerathome.org',
  },
  {
    'name': 'West Valley Community Services',
    'info': ['hunger', 'food', 'low income', 'poverty'],
    'address': '10104 Vista Dr, Cupertino, CA 95014',
    'website': 'http://wvcommunityservices.org',
    'email': 'volunteer@wvcommunityservices.org',
  },
  {
    'name': 'St. Joseph\'s Family Center',
    'info': ['hunger', 'homelessness', 'community', 'service'],
    'address': '7950 Church Street, Suite A, Gilroy, CA 95020',
    'website': 'https://stjosephsgilroy.org/',
    'email': 'vickym@stjosephsgilroy.org',
  },
  {
    'name': 'AIA Association of Indo Americans',
    'info': ['india', 'culture'],
    'address': '',
    'website': 'http://aiaevents.org',
    'email': 'bayareamela@gmail.com',
  },
  {
    'name': 'Art of Living',
    'info': ['india', 'meditation', 'cultural', 'yoga'],
    'address': '',
    'website': 'http://artofliving.org/us-en',
    'email': 'youthprograms@iahv.org',
  },
  {
    'name': 'Tamil Nadu Foundation',
    'info': ['india', 'youth', 'women', 'health', 'rural'],
    'address': '7409 Green Hill Drive, Macungie, PA 18062',
    'website': 'http://tnfusa.org',
    'email': 'ushachandra75@gmail.com',
  },
  {
    'name': 'Hamsanada',
    'info': ['indian', 'classical Music', 'music', 'arts', 'creative'],
    'address': '',
    'website':
        'https://www.facebook.com/groups/413068226109364/discussion/preview',
    'email': 'teachers@sripadukaacademy.com',
  },
  {
    'name': 'Nikkei Matsuri Foundation',
    'info': ['japan', 'japanese', 'cultural', 'community', 'service'],
    'address': '640 N. 5th St., San Jose, CA 95112',
    'website': 'http://nikkeimatsuri.org',
    'email': 'lesly@nikkeimatsuri.org',
  },
  {
    'name': 'Jewish Family Services of Silicon Valley',
    'info': ['jewish', 'family', 'adults', 'children'],
    'address': '14855 Oka Road, Suite 202, Los Gatos CA 95032',
    'website': 'http://jfssv.org',
    'email': 'rfineman@jfssv.org',
  },
  {
    'name': 'Silicon Valley Korean School',
    'info': ['korean', 'education', 'language'],
    'address': '10100 Finch Ave, Cupertino, CA 95014',
    'website': 'http://svks.org',
    'email': 'sungyeon.choi@svks.org; admin@svks.org',
  },
  {
    'name': 'Tomahawks Lacrosse',
    'info': ['lacrosse', 'sports', 'athletics', 'camps'],
    'address': '1955 Tasso Street. Palo Alto, CA 94301',
    'website': 'http://tomahawkslacrosse.org',
    'email': 'wglazier@sbcglobal.net',
  },
  {
    'name': 'Hello Languages',
    'info': ['languages', 'education', 'kids', 'children', 'students'],
    'address': '',
    'website': 'http://hellolanguages.org',
    'email': 'hellolanguagesnonprofit@gmail.com',
  },
  {
    'name': 'White Stag Leadership Development Academy',
    'info': ['leadership', 'youth'],
    'address': '33 Soledad Drive, Monterey, CA 93940',
    'website': 'http://whitestagmonterey.com',
    'email': 'connie@whitestagcamp.org',
  },
  {
    'name': 'Our City Forest',
    'info': [],
    'address': '',
    'website': 'http://ourcityforest.org',
    'email': 'volunteer@ourcityforest.org',
  },
  {
    'name': 'PALS Program',
    'info': ['legal', 'lawyers', 'mentorship', 'mentor', 'education'],
    'address': '',
    'website': 'http://palsprogram.org',
    'email': 'lauren@palsprograms.org',
  },
  {
    'name': 'Project More, Silicon Valley',
    'info': [
      'LGBTQ',
      'diversity',
      'community',
      'service',
      'arts',
      'cultural',
      'events'
    ],
    'address': '1700 De La Cruz Blvd, Suite D2, Santa Clara, CA 95050',
    'website': 'http://domoreproject.org',
    'email': 'contact@domoreproject.org',
  },
  {
    'name': 'San Jose Public Libraries- Edenvale Branch',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '101 Branham Ln E, San Jose, CA 95111',
    'website': 'http://sjlibrary.org',
    'email': 'paul.wilson@sjlibrary.org',
  },
  {
    'name': 'San Jose Public Library- Almaden Branch',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '6445 Camden Ave, San Jose, CA 95120',
    'website': 'http://sjpl.org/teensreach',
    'email': 'joann.wang@sjlibrary.org',
  },
  {
    'name': 'San Jose Public Library- Cambrian Branch',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '1780 Hillsdale Ave, San Jose, CA 95124',
    'website': 'http://sjpl.org/cambrian',
    'email': 'thu-thao.tran@sjplibrary.org',
  },
  {
    'name': 'San Jose Public Library- Evergreen',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '2635 Aborn Rd, San Jose, CA 95121',
    'website': 'http://sjpl.org/evergreen',
    'email': 'lucy.lu@sjlibrary.org',
  },
  {
    'name': 'San Jose Public Library- Santa Theresa',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '290 International Cir, San Jose, CA 95119',
    'website': 'http://sjpl.org/santa-teresa',
    'email': 'michele.rowic@sjlibrary.org',
  },
  {
    'name': 'Saratoga Senior Center',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '',
    'website': 'http://sascc.org',
    'email': 'tylortaylor@sascc.org',
  },
  {
    'name': 'First Generation',
    'info': [
      'low income',
      'educaiton',
      'college',
      'under represented',
      'immigrant'
    ],
    'address': '',
    'website': 'http://firstgensupport.org',
    'email': 'angela.c@firstgensupport.org',
  },
  {
    'name': 'VT Seva',
    'info': [
      'low income',
      'youth',
      'food',
      'india',
      'students',
      'school',
      'college'
    ],
    'address': 'Princeton Junction, NJ 08550',
    'website': 'http://vtsworld.org',
    'email': 'archana.bindu@gmail.com',
  },
  {
    'name': 'Benefits Foundation',
    'info': ['martial arts', 'children', 'underprivileged'],
    'address': '',
    'website': '',
    'email': 'kyle@benefitsfoundation.org',
  },
  {
    'name': 'Student Corps',
    'info': ['math', 'stem', 'youth', 'students'],
    'address': '',
    'website': 'http://vcsstudentcorps.org',
    'email': 'cissych2001@yahoo.com',
  },
  {
    'name': 'U Channel Foundation',
    'info': ['media', 'chinese'],
    'address': '1177 Laurelwood Rd., Santa Clara, CA 95054',
    'website': 'http://uchanneltv.us/english.html',
    'email': 'gracehwang@uchanneltv.us',
  },
  {
    'name': 'RAFT',
    'info': [],
    'address': '',
    'website': 'http://raft.net',
    'email': 'volunteer@raft.net',
  },
  {
    'name': 'Good Samaritan Hospital',
    'info': ['medical', 'health', 'science'],
    'address': '2425 Samaritan Dr, San Jose, CA 95124',
    'website': 'https://goodsamsanjose.com/',
    'email': 'alicia.schwemer@hcahealthecare.com',
  },
  {
    'name': 'Regional Medical Center San Jose',
    'info': ['medical', 'hospital', 'health', 'science', 'stem'],
    'address':
        'Regional Medical Center of San Jose, 225 North Jackson Ave, San Jose CA 95116',
    'website':
        'https://regionalmedicalsanjose.com/community/junior-volunteer-application.dot',
    'email': 'Jeanette.Yates@hcahealthcare.com',
  },
  {
    'name': 'Meet The Challenge',
    'info': ['ministry', 'faithbased', 'community', 'homeless'],
    'address': 'San Jose, CA 95153',
    'website': 'http://meetthechallenge.net',
    'email': 'charlesblackn@aol.com',
  },
  {
    'name': 'San Lorenzo Vally Museum',
    'info': ['museum', 'education', 'arts', 'culture'],
    'address': '12547 Highway 9, Boulder Creek, CA 95006',
    'website': 'http://slvmuseum.com',
    'email': 'slvhm@cruzio.com',
  },
  {
    'name': 'Santa Theresa Music and Arts',
    'info': ['music', 'arts', 'culture'],
    'address': '',
    'website': 'https://santateresamusic.com/',
    'email': 'persident@santateresamusic.com',
  },
  {
    'name': 'Academy of Music and Arts for Special Education',
    'info': ['music', 'arts', 'education', 'creative'],
    'address':
        'Valley Church of Cupertino, 10885 N Stelling Rd., Cupertino, CA 95014',
    'website': 'http://amaseus.org/about-us.html',
    'email': 'volunteer@amase.us',
  },
  {
    'name': 'Music Students Servant League',
    'info': ['music', 'arts', 'performance', 'cultural'],
    'address': '',
    'website':
        'http://mtacsacb.org/student-programs/music-student-service-league',
    'email': 'rosalynweng@gmail.com',
  },
  {
    'name': 'Eternity Band',
    'info': ['music', 'band', 'art', 'community'],
    'address': '',
    'website': 'http://eternityband.org',
    'email': 'admin@funyouth.us',
  },
  {
    'name': 'Crescendo Connect',
    'info': ['music', 'creative', 'art', 'family', 'community'],
    'address': '',
    'website': 'http://crescendoconnect.org',
    'email': 'aidanwilliams@gmail.com',
  },
  {
    'name': 'California School of Music and Art',
    'info': ['music', 'creative', 'art', 'students'],
    'address': 'Finn Center, 230 San Antonio Circle, Mountain View, CA 94040',
    'website': 'http://arts4all.org',
    'email': 'musicclasses@arts4all.org',
  },
  {
    'name': 'Evergreen Valley Youth Orchestra',
    'info': [
      'music',
      'education',
      'art',
      'creative',
      'students',
      'kids',
      'children'
    ],
    'address': 'Grace Church, 2650 Aborn Road, San Jose, CA 95121-1203',
    'website': 'http://evyouthorchestra.weebly.com',
    'email': 'info.evyo@gmail.com',
  },
  {
    'name': 'MusicNBrain',
    'info': ['music', 'performance', 'students', 'children', 'kids', 'art'],
    'address': '',
    'website': 'http://musicnbrain.com',
    'email': 'infor@musicnbrain.org',
  },
  {
    'name': 'Almaden Youth Musician',
    'info': ['music', 'seniors', 'arts'],
    'address': '',
    'website': 'http://almadenyouthmusicians.org',
    'email': 'almadenyouth@gmail.com',
  },
  {
    'name': 'Love Through Music',
    'info': ['music', 'undeserved', 'art', 'creative', 'community'],
    'address': 'Arcadia, CA 91077',
    'website': 'https://www.lovethrough-music.org/',
    'email': 'Jeston.lu@warriorlife.net',
  },
  {
    'name': 'Hakone Gardens Estate And Gardens',
    'info': ['nature', 'garden', 'japanese', 'plants'],
    'address': '21000 Big Basin Way, Saratoga, CA  95070',
    'website': 'http://hakone.com',
    'email': 'chiharu.yabe@hakonegardens.org',
  },
  {
    'name': 'Creek Connections Action Group',
    'info': ['nature', 'outdoor', 'community'],
    'address': '',
    'website': 'http://cleanacreek.org',
    'email': 'volunteer@valleywater.org',
  },
  {
    'name': 'California Native Plant Society',
    'info': ['nature', 'plant'],
    'address': '3921 East Bayshore Road, Suite 205, Palo Alto, CA 94303',
    'website': 'http://cnps-scv.org',
    'email': 'joosey@me.com.',
  },
  {
    'name': 'With A Thousand Crames',
    'info': ['origanmi', 'happines', 'culture'],
    'address': '',
    'website': 'http://withathousandcranes.com',
    'email': 'withathousandcrames@gmail.com',
  },
  {
    'name': 'Aubri Brown club',
    'info': ['parents', 'care'],
    'address': '9800 Lantz Drive, Morgan Hill, CA 95037',
    'website': 'http://theaubribrownclub.org',
    'email': 'abrown@theaubribrownclub.org',
  },
  {
    'name': 'Word of Grace',
    'info': ['parents', 'enrichment', 'education', 'youth', 'language'],
    'address': '2360 McLaughlin Ave, San Jose, CA 95122',
    'website': 'http://wordofgraceschool.org',
    'email': 'info@worgcs.org',
  },
  {
    'name': 'East Bay Park Regional District',
    'info': ['park', 'nature', 'community'],
    'address': '2950 Peralta Oaks Court, Oakland, CA 94605',
    'website': 'http://ebparks.org',
    'email': 'MEvans@ebparks.org',
  },
  {
    'name': 'Santa Clara County Parks',
    'info': ['park', 'nature', 'outdoors', 'adventure'],
    'address': '',
    'website': 'https://parks.sccgov.org/home',
    'email': 'volunteer@PRK.SCCGOV.ORG',
  },
  {
    'name': 'Sunnyvale Explorer Program',
    'info': ['police', 'training', 'youth'],
    'address': '456 W. Olive Ave., Sunnyvale, CA 94086',
    'website':
        'http://sunnyvale.ca.gov/your-government/departments/public-safety/public-safety-services/community-programs',
    'email': 'noconnell@sunnyvale.ca.gov',
  },
  {
    'name': 'Portuguese Order of the Holy Ghost Lodge',
    'info': ['portugal', 'portuguese', 'community', 'service', 'cultural'],
    'address': '',
    'website': 'https://www.facebook.com/sfv.lodge?mibextid=LQQJ4d',
    'email': 'otto79@sbcglobal.net',
  },
  {
    'name': 'City Team',
    'info': ['poverty', 'community', 'homelessness'],
    'address': '2306 Zanker Rd., San Jose, CA 95131',
    'website': 'http://cityteam.org',
    'email': 'gdo@cityteam.org',
  },
  {
    'name': 'Downtown Streets Team',
    'info': ['poverty', 'community', 'homelessness'],
    'address': '1671 The Alameda #301, San Jose, CA 95126',
    'website': 'http://streetsteam.org',
    'email': 'Latisha@streetsteam.org',
  },
  {
    'name': 'Family Supportive Housing',
    'info': ['poverty', 'community', 'homelessness'],
    'address': '692 N. King Road, San Jose, CA 95133',
    'website': 'http://familysupportivehousing.org',
    'email': 'Community@familysupportivehousing.org',
  },
  {
    'name': 'Sacred Heart Community Services',
    'info': ['poverty', 'community', 'support'],
    'address': '1381 South First Street, San Jose, CA 95110',
    'website': 'https://www.sacredheartcs.org/',
    'email': 'sergiog@sacredheartcs.org',
  },
  {
    'name': 'Salvation Army',
    'info': ['poverty', 'homelessness', 'community', 'support', 'outreach'],
    'address': '',
    'website': 'https://www.salvationarmy.org/',
    'email': 'Liwayway.Gimenez@usw.salvationarmy.org',
  },
  {
    'name': 'Reading Partners',
    'info': ['reading', 'literacy', 'low income under preveliged', 'children'],
    'address': '638 3rd Street, Oakland, CA 94607',
    'website': 'http://readingpartners.org/location/silicon-valley',
    'email': 'chris.johnson@readingpartners.org',
  },
  {
    'name': 'Rescue The Underdog',
    'info': ['rescue', 'dog', 'adoption', 'animals'],
    'address': '',
    'website': 'http://rescuetheunderdog.com',
    'email': 'curtk320@gmail.com',
  },
  {
    'name': 'Robotics Education & Competition Foundation',
    'info': ['robotics', 'VEX', 'science', 'technology', 'stem'],
    'address': '',
    'website': 'http://roboticseducation.org',
    'email': 'ferndzjoe@gmail.com',
  },
  {
    'name': 'San Jose Christian School',
    'info': ['school', 'education', 'christian'],
    'address': '1300 Sheffield Avenue, Campbell, CA, 95008',
    'website': 'http://sjchristian.org/giving/walk-a-thon.cfm',
    'email': 'info@sjchristian.org',
  },
  {
    'name': 'One People On Cosmos',
    'info': ['science', 'astronomy', 'stem'],
    'address': '',
    'website': 'http://onepeopleonecosmos.org',
    'email': 'contact@onepeopleonecosmos.org',
  },
  {
    'name': 'Learning Landmark',
    'info': ['science', 'tech', 'stem', 'students', 'kids', 'children'],
    'address': '',
    'website': 'http://learninglandmark.com',
    'email': 'sanjana.ryali@warriorlife.net',
  },
  {
    'name': 'Sourcewise',
    'info': ['seniors', 'caretakers', 'support', 'community'],
    'address': '3100 De La Cruz Blvd, Suite 310, Santa Clara, CA 95054',
    'website': 'http://mysourcewise.com',
    'email': 'volunteer@mysourcewise.com',
  },
  {
    'name': 'Rossinca Heritage School',
    'info': ['slavic', 'language', 'literacy', 'community', 'support'],
    'address': '2095 Park Avenue, San Jose, CA 95126',
    'website': 'http://rossinca.org',
    'email': 'ykhitykh@rossinca.org',
  },
  {
    'name': 'Pajama Program',
    'info': ['sleep', 'kids', 'children', 'support'],
    'address': '171 Madison Avenue, Suite 1409, New York, NY 10016',
    'website': 'https://pajamaprogram.org/',
    'email': 'libby@bluetartan.com',
  },
  {
    'name': 'San Jose Lady Sharks',
    'info': ['softball', 'baseball', 'girls', 'athletics', 'sports'],
    'address': '2001 Cottle Rd., San Jose, CA 95125',
    'website': 'http://ladysharksfastpitch.com',
    'email': 'kelli.formosa@gmail.com',
  },
  {
    'name': 'Life Services Alternatives',
    'info': ['special needs', 'adults', 'health', 'disability'],
    'address': '260 W Hamilton Ave, Campbell, CA 95008',
    'website': 'http://lsahomes.org',
    'email': 'cmoreton@lsahomes.org',
  },
  {
    'name': 'FCSN (Friends of Children with Special Needs)',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '2300 Peralta Blvd., Fremont, CA 94536',
    'website': 'http://fcsn1996.org',
    'email': 'mannchingw@fcsn1996.org',
  },
  {
    'name': 'Home of Hope',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '1177 California Street #1424, San Francisco, CA 94108',
    'website': 'http://hohinc.org',
    'email': 'smilehoh.manovikas@gmail.com',
  },
  {
    'name': 'Inclusive World',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '106 S Park Victoria Dr, Milpitas, CA 95035',
    'website': 'https://inclusiveworld.org',
    'email': 'ramya.rajam@inclusiveworld.org',
  },
  {
    'name': 'South Valley Fish Food Pantry',
    'info': [],
    'address': '',
    'website': 'http://www.svfish.org',
    'email': 'fishpantryvolunteer@ gmail.com',
  },
  {
    'name': 'InFUSE',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '',
    'website': '',
    'email': 'lpundiramu@gmail.com',
  },
  {
    'name': 'Warpitect',
    'info': ['special needs', 'education'],
    'address': '',
    'website': 'https://www.warpitect.org',
    'email': 'Warpitect@gmail.com',
  },
  {
    'name': 'Science of Spirituality',
    'info': ['spiritual', 'sikh', 'indian', 'community', 'service'],
    'address': '4105 Naperville Road, Lisle, IL 60532',
    'website': 'http://sos.org',
    'email': 'mail2ashwini@gmail.com',
  },
  {
    'name': 'BAWSI (Bay Area Womens Sports Initiative)',
    'info': ['sports', 'athletics', 'girls', 'children'],
    'address': '1922 The Alameda, Suite 420, San Jose, CA 95126',
    'website': 'http://bawsi.org',
    'email': 'courtney@bawsi.org',
  },
  {
    'name': 'American Junior Golf Association',
    'info': ['sports', 'athletics', 'golf'],
    'address': '1980 Sports Club Drive, Braselton, GA 30517',
    'website': 'http://ajga.org',
    'email': 'ksalzer@ajga.org',
  },
  {
    'name': 'Infinity Sports Club',
    'info': ['sports', 'camps', 'athletics', 'hockey', 'soccer'],
    'address': '',
    'website': 'http://Infinitysportsclub.org',
    'email': 'superxmom@yahoo.com',
  },
  {
    'name': 'Bay Area Chess Association',
    'info': ['sports', 'chess'],
    'address': '2050 Concourse Drive #42, San Jose, CA 95131',
    'website': 'https://bayareachess.com/index',
    'email': 'jeff@bayareachess.com',
  },
  {
    'name': 'Almaden Riptide Swim',
    'info': ['sports', 'swimming', 'athletics'],
    'address': '1079 Shadow Brook Drive, San Jose, CA 95120',
    'website': 'https://www.almadenriptides.com',
    'email': 'thealmadenriptide@gmail.com',
  },
  {
    'name': 'Chabot Space and Science Museum',
    'info': ['stem', 'science', 'space', 'educaiton'],
    'address': '10000 Skyline Blvd., Oakland, California 94619',
    'website': 'http://chabotspace.org',
    'email': 'atruitt@chabotspace.org',
  },
  {
    'name': 'Santa Clara Sister Cities',
    'info': ['students', 'exchange program', 'education', 'leadership'],
    'address': 'Santa Clara, CA 95052',
    'website': 'http://santaclarasistercities.org',
    'email': 'president@santaclarasistercities.org',
  },
  {
    'name': 'Mission Possible Teens',
    'info': [
      'students',
      'kids',
      'children',
      'tution',
      'tutor',
      'stem',
      'sports',
      'math',
      'science'
    ],
    'address': '39510 Paseo Padre Pkwy Ste 310, Fremont , CA 94538',
    'website': 'http://mptfusa.org',
    'email': 'hatphile@gmail.com',
  },
  {
    'name': 'Nor Cal Aquatics',
    'info': ['swimming', 'aquatics', 'athletics', 'sports', 'water polo'],
    'address': '',
    'website': 'https://www.norcal-aquatics.com',
    'email': 'norcalaquaticswp@gmail.com',
  },
  {
    'name': 'Quicksilver Swimming Program',
    'info': ['swimming', 'athletics', 'students', 'sports', 'swim'],
    'address': '',
    'website': 'http://teamunify.com/team/pcqs/page/home',
    'email': 'carrie@swimqss.org',
  },
  {
    'name': 'Encore Swim Team',
    'info': ['swimming', 'swim', 'sports', 'athletics'],
    'address': '8127 Mesa Drive, Suite B206-223, Austin, Texas 78759',
    'website': 'http://hencoreswim.swimtopia.com',
    'email': 'mkbarte@gmail.com',
  },
  {
    'name': 'Table Tennis America Foundation',
    'info': ['table tennis', 'sports', 'athletics'],
    'address': '42670 Albrae St, Fremont, CA 94538, USA',
    'website': 'http://ttamerica.org',
    'email': 'info@attamerica.org',
  },
  {
    'name': 'Connexpedition',
    'info': ['taiwan', 'tutor', 'english', 'education', 'chinese'],
    'address': '',
    'website': 'http://connexpedition.com',
    'email': 'connecpedition@wceo.org',
  },
  {
    'name': 'The Tech Interactive',
    'info': ['technology', 'stem', 'science', 'maths', 'camps', 'museum'],
    'address': '201 S. Market St., San Jose, CA 95113',
    'website': 'http://thetech.org',
    'email': 'lmunzel@thetech.org',
  },
  {
    'name': 'Bright Future Teens',
    'info': ['teens', 'education', 'leadership'],
    'address': '',
    'website': 'http://brightfutureteen.com',
    'email': 'brightfutureteens@gmail.com',
  },
  {
    'name': 'The Young Expressionists- VCHS Student Organization',
    'info': [],
    'address': '',
    'website': 'http://theyoungexpressionists.org',
    'email': 'emma.zhang@warriorlife.net/jacqueline.lao@warriorlife.net',
  },
  {
    'name': 'Teens Volunteer',
    'info': ['teens', 'foodbank', 'education', 'books', 'library'],
    'address': '',
    'website': 'http://teensvolunteer.org',
    'email': 'sydney@teensvolunteer.org',
  },
  {
    'name': 'Neighborhood Teens',
    'info': ['teens', 'students', 'community', 'service'],
    'address': '',
    'website': 'http://www.nteens.net/home',
    'email': 'info@nteens.net',
  },
  {
    'name': 'BATA (Bay Area Telugu Association)',
    'info': ['telegu', 'culture', 'india'],
    'address': '39120 Argonaut Way # 555,Fremont CA 94538',
    'website': 'http://bata.org',
    'email': 'info@bata.org',
  },
  {
    'name': 'WETA (Women\'s Empowerment Telugu Association)',
    'info': ['telegu', 'india', 'women', 'empowerment'],
    'address': '1114 W 6th Street, Suite #110, Hanford, CA 93230',
    'website': 'http://wetaglobal.org',
    'email': 'sailaja.kalluri@gmail.com',
  },
  {
    'name': 'Our City Forest',
    'info': ['trees', 'nature', 'plant', 'forest', 'community', 'service'],
    'address': '1195 Clark St. San Jose, CA 95125',
    'website': 'http://ourcityforest.org',
    'email': 'erika@ourcityforest.org',
  },
  {
    'name': 'Silicon Valley Triathalon Event',
    'info': ['triathalon', 'running', 'sports', 'athletics'],
    'address': '',
    'website':
        'http://runsignup.com/Race/Volunteer/CA/Cupertino/SiliconValleyKidsTriathlon',
    'email': 'vrmanathan@hotmail.com',
  },
  {
    'name': 'Flowing Waters Foundation',
    'info': ['tutor', 'education', 'children', 'under previleged ML'],
    'address': '',
    'website': 'http://flowingwatersfoundation.org',
    'email': 'fwf@flowingwatersfoundation.org',
  },
  {
    'name': 'Engin',
    'info': ['ukraine', 'education', 'english', 'communicate', 'language'],
    'address': '',
    'website': 'http://enginprogram.org',
    'email': 'a.nikulina@enginprogram.org',
  },
  {
    'name': 'Sunday Friends',
    'info': ['underserved', 'health', 'food', 'education', 'poverty'],
    'address': '645 Wool Creek Drive, 2nd Floor Suite A, San Jose, CA 95112',
    'website': 'http://Sundayfriends.org',
    'email': 'andy@sundayfriends.org',
  },
  {
    'name': 'Learn 2 B',
    'info': [
      'undeserved',
      'education',
      'tutoring',
      'kids',
      'students',
      'children'
    ],
    'address': '',
    'website': 'http://learntobe.org',
    'email': 'ashley.elias@learntobe.com',
  },
  {
    'name': 'Valle Verde',
    'info': ['vegetable', 'nature', 'garden', 'environment', 'food'],
    'address': '691 W San Carlos St., San Jose, CA 95126',
    'website': 'http://valleyverde.org',
    'email': 'darshini@valleyverde.org',
  },
  {
    'name': 'Vietnamese Christian Restoration Ministry',
    'info': ['veitnamese', 'vietnam', 'community', 'service'],
    'address': 'Dallas, TX 75381',
    'website': 'http://vcrministry.org',
    'email': 'trongmdu@yahoo.com',
  },
  {
    'name': 'San Jose VA Clinic',
    'info': ['veteran', 'community', 'support'],
    'address': '5855 Silver Creek Valley Place, San Jose, CA 95138-1059',
    'website':
        'https://www.va.gov/palo-alto-health-care/locations/san-jose-va-clinic/',
    'email': 'Miriam.Fenwick@va.gov',
  },
  {
    'name': 'San Jose Vietnamese Running Club (SJVRC)',
    'info': ['vietnam', 'children', 'community', 'support'],
    'address': '2266 Senter Rd, Suite 146, San Jose, CA 95112',
    'website': 'http://sjvrc.org',
    'email': 'jenie9699@gmail.com',
  },
  {
    'name':
        'NCAVAD, Inc. (North California Association of Vietnamese American Dentists)',
    'info': ['vietnamese', 'dentist', 'health', 'doctor', 'community'],
    'address': '',
    'website': 'http://ncavad.org',
    'email': 'khanhha_le@yahoo.com',
  },
  {
    'name': 'United States Youth Volleyball League',
    'info': ['volleyball', 'athletics', 'sports', 'kids'],
    'address': '2771 Plaza Del Amo, Suite 808, Torrance, CA 90503',
    'website': 'http://usyvl.org',
    'email': 'bobby@usyvl.org',
  },
  {
    'name': 'San Jose Express Aquatics',
    'info': ['water polo', 'swimming', 'athletics', 'aquatics', 'sports'],
    'address': '​18900 Prospect Road, Saratoga, CA​ 95070',
    'website': 'http://www.sanjoseexpress.org',
    'email': 'ccarlson@vcs.net',
  },
  {
    'name': 'Silicon Valley Outlaws',
    'info': ['waterpolo', 'swimming', 'athletics', 'sports'],
    'address': '100 Skyway Dr, San Jose, CA 95111',
    'website': 'http://svoutlaws.com',
    'email': 'ccarlson@vcs.net',
  },
  {
    'name': 'Lindsay Wildlife Center',
    'info': ['wildlife', 'nature', 'animal'],
    'address': '1931 First Avenue, Walnut Creek, CA 94597',
    'website': 'http://lindsaywildlife.org',
    'email': 'youthprograms@lindsaywildlife.org',
  },
  {
    'name': 'Wildlife Center of Silicon Valley',
    'info': ['wildlife', 'nature', 'animal', 'nature'],
    'address': '3027 Penitencia Creek Rd, San Jose, CA 95132',
    'website': 'http://wcsv.org',
    'email': 'volunteercoordinator@wcsv.org',
  },
  {
    'name': 'Cheyenne River Youth Project',
    'info': ['youth,'],
    'address': '702 4th Street, Eagle Butte, SD 57625',
    'website': 'http://lakotayouth.org',
    'email': 'Youthpd.cryp@gmail.com',
  },
  {
    'name': 'Youth Allicance',
    'info': [
      'youth',
      'academic',
      'education',
      'leadership',
      'economic',
      'community',
      'service'
    ],
    'address': '',
    'website': 'http://site.youthall.org',
    'email': 'lillian@youthall.org',
  },
  {
    'name': 'YUPP (Youth Utilizing Power and Prayer)',
    'info': [
      'youth',
      'arts',
      'music',
      'science',
      'math',
      'learning',
      'culture',
      'community',
      'camps'
    ],
    'address': 'Palo Alto, CA 94303',
    'website': 'http://yupporg.com',
    'email': 'shelene.booker@yupporg.com',
  },
  {
    'name': 'Youth4good',
    'info': ['youth', 'community', 'service', 'leadership', 'food', 'hunger'],
    'address': '',
    'website': 'http://youth4good.us',
    'email': 'patty@youth4good.us',
  },
  {
    'name': 'Empower Excel',
    'info': ['youth', 'kids', 'community'],
    'address': 'San Jose, CA 95151',
    'website': 'http://empowerexcel.org',
    'email': 'info@empowerexcel.org',
  },
  {
    'name': 'Youth Priority',
    'info': ['youth', 'sick', 'health', 'fundraising'],
    'address': '',
    'website': 'https://youthpriority.mystrikingly.com',
    'email': 'support@youthpriority.org',
  },
  {
    'name': 'STAR Arts',
    'info': ['youth', 'teens', 'arts', 'music', 'cultural', 'theater'],
    'address': '7393 Monterey Road, Gilroy, CA. 95020',
    'website': 'http://starartseducation.org',
    'email': 'mac.star.arts@gmail.com',
  },
  {
    'name': 'American Cancer Society Discovery Shop',
    'info': [],
    'address': '1103 Branham Lane, San Jose, CA 95118',
    'website':
        'https://www.cancer.org/donate/discovery-shops-national/california-discovery-shops/san-jose.html',
    'email': 'Patricia.chell@cancer.org',
  },
  {
    'name': 'American Chinese Youth Performing Arts Foundation',
    'info': [],
    'address': '967 Hall St, San Carlos, CA 94070',
    'website':
        'http://californiaexplore.com/company/04287985/american-chinese-youth-performing-art-foundation',
    'email': 'qionghuang888@yahoo.com',
  },
  {
    'name': 'Bret Harte Middle School Programs',
    'info': [],
    'address': '7050 Bret Harte Drive, San José, CA 95120',
    'website': 'http://bretharte.sjusd.org',
    'email': 'mrouiller1@yahoo.com',
  },
  {
    'name': 'Just Serve',
    'info': [],
    'address': '',
    'website': 'https://www.justserve.org/',
    'email': 'ray@froess.com',
  },
  {
    'name': 'Merryhill Milpitas Middle School',
    'info': [],
    'address': '1500 Yosemite Dr, Milpitas, CA 95035',
    'website': 'http://merryhillschool.com/elementary/san-jose/milpitas',
    'email': 'Quinn.Letan@merryhillschool.com',
  },
  {
    'name': 'Morgan Hills Aquatic Center',
    'info': [],
    'address': '17575 Peak Avenue, Morgan Hill, CA 95037',
    'website': 'http://morgan-hill.ca.gov/189/Aquatics-Center-AC',
    'email': 'suzie.nguyen@morganhill.ca.gov',
  },
  {
    'name': 'PGA Jr. Foundation',
    'info': [],
    'address': '',
    'website': '',
    'email': 'chenry@ranchodelpueblo.com',
  },
  {
    'name': 'Quaran Tutors',
    'info': [],
    'address': '',
    'website': 'http://quarantutors.com',
    'email': 'lancynthia05@gmail.com',
  },
  {
    'name': 'Sky Ensemble',
    'info': [],
    'address': '',
    'website': 'http://skyensemble.org/',
    'email': 'ensemble.sky@gmail.com',
  },
  {
    'name': 'Smile CARD',
    'info': [],
    'address': '',
    'website': 'https://www.smilecard.org/',
    'email': 'sc.volunteer.outreach.coordinator@gmail.com',
  },
  {
    'name': 'Special Olympics',
    'info': [],
    'address': '3480 Buskirk Ave #340, Pleasant Hill, CA 94523',
    'website': 'http://sonc.org',
    'email': 'cameronb@sonc.org',
  },
  {
    'name': 'Starting Arts',
    'info': [],
    'address': '525 Parrott St, San Jose CA 95112',
    'website': 'http://startingarts.com',
    'email': 'michelle@startingarts.com',
  },
  {
    'name': 'Tian Mu',
    'info': [],
    'address': '',
    'website': '',
    'email': 'vshao1@gmail.com',
  },
  {
    'name': 'Tzu Chi',
    'info': [],
    'address': '',
    'website': 'http://tzuchi.us',
    'email': 'ps1006@gmail.com',
  },
  {
    'name': 'UC Master Gardeners, Santa Clara County',
    'info': [],
    'address': '1553 Berger Drive, San Jose, CA 95112',
    'website': 'http://mgsantaclara.ucanr.edu',
    'email': 'lodiekmann@ucanr.edu.',
  },
  {
    'name': 'Valley Splash',
    'info': [],
    'address': '',
    'website': 'http://www.teamunify.com',
    'email': 'kparizi@vcs.net',
  },
  {
    'name': 'Yew Chung International School',
    'info': [],
    'address': '310 Easy Street, Mountain View, CA 94043',
    'website': 'http://ycis-sv.com',
    'email': 'beckyq@sv.ycef.com',
  },
  {
    'name': 'Youth4Difference',
    'info': [],
    'address': '',
    'website': '',
    'email': 'youth4difference.change.it@gmail.com',
  },
];

class Items {
  final name;
  final info;
  final address;
  final website;
  final email;

  const Items(this.name, this.info, this.address, this.website, this.email);
}

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'wearevolunteenz',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light().copyWith(
            primary: const Color.fromARGB(255, 0, 206, 203),
            secondary: const Color.fromARGB(255, 168, 248, 168),
            tertiary: const Color.fromARGB(255, 255, 237, 102),
            error: const Color.fromARGB(255, 255, 94, 91),
            background: const Color.fromARGB(255, 255, 255, 234),
            surface: const Color.fromARGB(255, 168, 248, 168),
          ),

          //primaryColor: Color.fromARGB(255, 0, 206, 203),
          //primarySwatch:  Color.fromARGB(255, 0, 206, 203)
        ),
        home: MyHomePage(
          items: List.generate(
            orgs.length,
            (i) => Items(
              orgs[i]['name'],
              orgs[i]['info'],
              orgs[i]['address'],
              orgs[i]['website'],
              orgs[i]['email'],
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  const MyHomePage({super.key, required this.items});

  final List<Items> items;

  State<MyHomePage> createState() => _MyHomePageState(items: items);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  _MyHomePageState({required this.items});
  final List<Items> _selectedItems = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Items> items;
  final List<Items> _results = [];
  String searchText = '';
  String locText = '';
  String listAmount = "";

  void _handletext(String input) {
    _results.clear();
    searchText = input;
    for (var item in items) {
      if (item.name!.toLowerCase().contains(searchText.toLowerCase()) ||
          item.info!
              .join(',')
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
        if (item.address!.toLowerCase().contains(locText.toLowerCase())) {
          setState(() {
            _results.add(item);
          });
        }
      }
    }
    listText();
  }

  void _handleloc(String input) {
    _results.clear();
    locText = input;
    for (var item in items) {
      if (item.address!.toLowerCase().contains(input.toLowerCase())) {
        if (item.name!.toLowerCase().contains(searchText.toLowerCase()) ||
            item.info!
                .join(',')
                .toLowerCase()
                .contains(searchText.toLowerCase())) {
          setState(() {
            _results.add(item);
          });
        }
      }
    }
    listText();
  }

  void listText() {
    if (searchText.isEmpty && locText.isEmpty) {
      setState(() {
        listAmount = "${items.length} organizations";
      });
    } else {
      setState(() {
        listAmount =
            "Found ${_results.length} out of ${items.length} organizations";
      });
    }
  }

  bool isSelected(i) {
    for (var s in _selectedItems) {
      if (s.name == i.name) return true;
    }
    return false;
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.secondary, fontSize: 40);
    //int selectedItem = 0;

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          centerTitle: true,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'weare',
                  style: style,
                  textAlign: TextAlign.center,
                ),
                Image.asset('assets/logo.png', scale: 6),
                Text(
                  'olunteenz',
                  style: style,
                  textAlign: TextAlign.center,
                ),
              ]),
        ),
        body: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(8.0),
                color: theme.colorScheme.primary,
                child: TextField(
                  onChanged: _handletext,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Search',
                  ),
                ),
              )),
              SizedBox(
                width: 150,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: theme.colorScheme.primary,
                  child: TextField(
                    onChanged: _handleloc,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.room),
                      filled: true,
                      border: OutlineInputBorder(),
                      hintText: 'Location',
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  color: theme.colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                        ((searchText.isEmpty && locText.isEmpty)
                                ? '${items.length} organizations'
                                : listAmount) +
                            (_selectedItems.isNotEmpty
                                ? ', ${_selectedItems.length} selected'
                                : ''),
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.left),
                  ),
                ),
              ]),
          Expanded(
            child: (searchText.isEmpty && locText.isEmpty)
                ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          tileColor: theme.colorScheme.background,
                          selectedTileColor: theme.colorScheme.tertiary,
                          selectedColor: Colors.black,
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InfoScreen(item: items[index]),
                                ),
                              );
                              // selectedItem = index;
                              // Scaffold.of(context).openEndDrawer();
                              //_openEndDrawer(items[index]);
                            },
                            style: TextButton.styleFrom(
                              /*
                              backgroundColor:
                                  const Color.fromARGB(255, 219, 219, 219),
                                  */
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('ⓘ',
                                style: TextStyle(
                                  fontSize: 24, /* color: Colors.black*/
                                )),
                          ),
                          title: Text(items[index].name),
                          contentPadding: const EdgeInsets.only(left: 10),
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          selected: isSelected(items[index]),
                          onTap: () {
                            setState(() {
                              if (isSelected(items[index])) {
                                _selectedItems.remove(items[index]);
                              } else {
                                _selectedItems.add(items[index]);
                              }
                            });
                          },
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                        child: ListTile(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5))),
                          tileColor: theme.colorScheme.background,
                          selectedTileColor: theme.colorScheme.tertiary,
                          selectedColor: Colors.black,
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InfoScreen(item: _results[index]),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              /*
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 128, 128, 128)),
                                  */
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(0)),
                            ),
                            child: const Text('ⓘ',
                                style: TextStyle(
                                  fontSize: 24, /*color: Colors.black*/
                                )),
                          ),
                          title: Text(_results[index].name),
                          contentPadding: const EdgeInsets.only(left: 10),
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -4),
                          selected: isSelected(_results[index]),
                          onTap: () {
                            setState(() {
                              if (isSelected(_results[index])) {
                                _selectedItems.remove(_results[index]);
                              } else {
                                _selectedItems.add(_results[index]);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ]),
        bottomNavigationBar: _selectedItems.isNotEmpty
            ? BottomAppBar(
                color: theme.colorScheme.primary,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Message_Page(selectedItems: _selectedItems),
                        ),
                      );
                    },
                    child: const Icon(Icons.mail, color: Colors.black)))
            : BottomAppBar(
                color: theme.colorScheme.primary,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.mail,
                      color: Colors.white,
                    ))));
  }
}

class InfoScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const InfoScreen({super.key, required this.item});

  // Declare a field that holds the Todo.
  final Items item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Organization Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(item.name + '\n',
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Catagories',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left),
                    // Text(item.info.join(', ')+'\n'),
                    Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: List.generate(item.info.length, (index) {
                          return Chip(
                            visualDensity: const VisualDensity(
                                vertical: -4, horizontal: -4),
                            label: Text(item.info[index]),
                            backgroundColor: theme.colorScheme.secondary,
                            padding: const EdgeInsets.only(
                                top: 0, left: 2, right: 2, bottom: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: const BorderSide(style: BorderStyle.none),
                          );
                        })),
                    const Text('\nAddress',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(item.address + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                    const Text('Website',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),

                    TextButton(
                      onPressed: () async {
                        Uri url = Uri.parse(item.website);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url); //forceWebView is true now
                        } else {
                          showSnackBar('Could not open website', context,
                              theme.colorScheme.error);
                        }
                      },
                      style: TextButton.styleFrom(
                        /*
                              backgroundColor:
                                  const Color.fromARGB(255, 219, 219, 219),
                                  */
                        padding: EdgeInsets.zero,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.website + '\n',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                    const Text('Email',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(item.email, textAlign: TextAlign.left, softWrap: true),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

class Message_Page extends StatefulWidget {
  @override
  const Message_Page({super.key, required this.selectedItems});

  final List<Items> selectedItems;

  State<Message_Page> createState() =>
      _Message_PageState(selectedItems: selectedItems);
}

class _Message_PageState extends State<Message_Page> {
  @override
  _Message_PageState({required this.selectedItems});

  final List<Items> selectedItems;

  // String _fileText = '';
  String msgBody = '';
  String msgSubj = '';
  String filePath = '';

  void _handleBody(String input) {
    setState(() {
      msgBody = input;
    });
  }

  void _handleSubj(String input) {
    setState(() {
      msgSubj = input;
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );

    if (result != null && result.files.single.path != null) {
      /// Load result and file details
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      File _file = File(result.files.single.path!);
      setState(() {
        filePath = _file.path;
      });
    } else {
      /// User canceled the picker
    }
  }

  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Message'),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: theme.colorScheme.background,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: _handleSubj,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Subject',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: theme.colorScheme.background,
                    child: TextField(
                      onChanged: _handleBody,
                      maxLines: null, // Set this
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter message here',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: theme.colorScheme.primary,
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                  child: filePath.isEmpty
                      ? const Icon(Icons.note_add_outlined, color: Colors.black)
                      : const Icon(Icons.task_outlined, color: Colors.black),
                  onPressed: () {
                    _pickFile();
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Send Gmail",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: (msgBody.isEmpty || msgSubj.isEmpty)
                                  ? Colors.grey
                                  : Colors.black)),
                    ],
                  ),
                  onPressed: () {
                    if (!(msgBody.isEmpty || msgSubj.isEmpty)) {
                      sendEmail();
                    }
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () {
                        GoogleSignInApi.signOut();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Signout",
                              style: TextStyle(
                                  fontFamily: 'Roboto', color: Colors.black)),
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Future<Null> testingEmail(String from, result, String to) async {

    var content = '''
Content-Type: multipart/mixed; boundary="foo_bar_baz"
MIME-Version: 1.0
From: ${from}
To: ${to}
Subject: ${msgSubj}

--foo_bar_baz
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

${msgBody}

''';


if (filePath.isNotEmpty) {
      String fileInBase64 = base64Encode(File(filePath).readAsBytesSync());

      final mimeType = lookupMimeType(filePath);
      final fileName = filePath.split('/').last;
      content = content + '''
--foo_bar_baz
Content-Type: ${mimeType}
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="${fileName}"

${fileInBase64}

''';
    }
    content = content + '''
--foo_bar_baz--
''';

    var bytes = utf8.encode(content);
    var base64 = base64Encode(bytes);
    var body = json.encode({'raw': base64});

    String url =
        'https://www.googleapis.com/gmail/v1/users/' + from + '/messages/send';

    final http.Response response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': result['Authorization'],
          'X-Goog-AuthUser': result['X-Goog-AuthUser'],
          'Accept': 'application/json',
          'Content-type': 'application/json'
        },
        body: body);
    final Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode != 200) {
      setState(() {
        print('error: ' + response.statusCode.toString());
        print(json.decode(response.body));
        print(data);
      });
      return;
    }
    print('ok: ' + response.statusCode.toString());
  }

  Future sendEmail() async {
    final theme = Theme.of(context);
    final user = await GoogleSignInApi.signin(theme, context);

    if (user == null) {
      showSnackBar('Google authentication failed', context, theme.colorScheme.error);
      return;
    }
    final auth = await user.authHeaders;
  
    var i = 0;
    for (var s in selectedItems) {
      try {
        await testingEmail(user.email, auth, s.email);
        i = i + 1;
      } on MailerException catch (e) {
        showSnackBar('${e.toString()}', context, theme.colorScheme.error);
      }
    }
    if (i == selectedItems.length) {
      showSnackBar('Sent all emails', context, theme.colorScheme.secondary);
    } else {
      showSnackBar('Sent ${i} of ${selectedItems.length} emails', context,
          theme.colorScheme.error);
    }
  
  /*
    final googleSignIn =
        GoogleSignIn(scopes: ['https://www.googleapis.com/auth/gmail.send']);
    await googleSignIn.signIn().then((data) async {
      await data?.authHeaders.then((result) async {
        var i = 0;
        for (var s in selectedItems) {
          try {
            await testingEmail(data.email, result, s.email);
            i = i + 1;
          } on MailerException catch (e) {
            showSnackBar('${e.toString()}', context, theme.colorScheme.error);
          }
        }
        if (i == selectedItems.length) {
          showSnackBar('Sent all emails', context, theme.colorScheme.secondary);
        } else {
          showSnackBar('Sent ${i} of ${selectedItems.length} emails', context,
              theme.colorScheme.error);
        }
      });
    });
  */
  }

  Future sendEmailOld() async {
    final theme = Theme.of(context);
    final user = await GoogleSignInApi.signin(theme, context);

    if (user == null) {
      showSnackBar(
          'Google authentication failed', context, theme.colorScheme.error);
      return;
    }

    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken!;

    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..subject = msgSubj
      ..text = msgBody
      ..from = Address(email, user.displayName);

    if (filePath.isNotEmpty) {
      message.attachments.add(FileAttachment(File(filePath)));
    }

    var i = 0;

    for (var s in selectedItems) {
      try {
        message.recipients = [s.email];
        await send(message, smtpServer);
        i = i + 1;
      } on MailerException catch (e) {
        showSnackBar('${e.toString()}', context, theme.colorScheme.error);
      }
    }
    if (i == selectedItems.length) {
      showSnackBar('Sent all emails', context, theme.colorScheme.secondary);
    } else {
      /*showSnackBar('Sent ${i} of ${selectedItems.length} emails', context,
          theme.colorScheme.error);*/
    }
  }
}

void showSnackBar(String text, context, color) {
  final snackBar = SnackBar(
    content:
        Text(text, style: const TextStyle(fontSize: 20, color: Colors.black)),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

class GoogleSignInApi {
  static final _googleSignIn =
      GoogleSignIn(scopes: ['https://www.googleapis.com/auth/gmail.send']);

  static Future<GoogleSignInAccount?> signin(theme, context) async {
    Widget _buildPopupDialog(BuildContext context) {
      final theme = Theme.of(context);
      return AlertDialog(
        title: const Text('Please sign into Google to allow sending Gmails',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            )),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5))),
        backgroundColor: theme.colorScheme.background,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[],
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final user = await _googleSignIn.signIn();
                Navigator.pop(context, user);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                      'assets/google_signin_buttons/ios/3x/btn_google_light_normal_ios@3x.png',
                      scale: 4),
                  const Text('Sign in with Google',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                      ))
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary),
                  child: const Text('Cancel')),
            ),
          ),
        ],
      );
    }

    if (await _googleSignIn.isSignedIn() && _googleSignIn.currentUser != null) {
      showSnackBar('Signed in: ${_googleSignIn.currentUser}', context,
          theme.colorScheme.secondary);
      return _googleSignIn.currentUser;
    } else {
      try {
        final user = await showDialog(
          context: context,
          builder: (BuildContext context) => _buildPopupDialog(context),
        );
        return user;
      } catch (err) {
        showSnackBar("${err.toString()}", context, theme.colorScheme.error);
        return null;
      }
    }
  }

  static Future signOut() => _googleSignIn.signOut();
}
