import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

var orgs = [
  {
    'name': 'Civil Air Patrol',
    'info': ['aerospace', 'space', 'stem', 'science', 'camps'],
    'address': '105 S. Hansell Street, Maxwell AFB, AL 36112',
    'website': 'https://www.gocivilairpatrol.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Adopt a Park',
    'info': [],
    'address': '',
    'website': 'http://partners.sanjosemayor.org/servesj',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'All Animal Rescue and Friends',
    'info': ['animal', 'nature'],
    'address': 'San Martin, CA 95046',
    'website': 'http://AARFlove.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Animal Assisted Happiness',
    'info': ['animal', 'youth', 'mental health'],
    'address': 'Baylands Park, 999 E Caribbean Dr, Sunnyvale, CA 94089',
    'website': 'http://animalassistedhappiness.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cal Color Academy - Fremont',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '47816 Warm Springs Blvd, Fremont, CA 94539',
    'website': 'http://calcolor.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cal Color Academy - Cupertino',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '10626 S De Anza Blvd, Cupertino, CA 95014',
    'website': 'http://calcolor.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cal Color Academy - Mountain View',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '612 San Antonio Rd, Mountain View, CA 94040',
    'website': 'http://calcolor.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cal Color Academy - San Jose',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '1711 Branham Ln, Ste 20, San Jose, CA 95118',
    'website': 'http://calcolor.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cal Color Academy - Newark',
    'info': ['art', 'children', 'kids', 'creative'],
    'address': '35467 Dumbarton Ct, Newark, CA 94560',
    'website': 'http://calcolor.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bay Area Glass Institute',
    'info': ['art', 'creative', 'glass blowing'],
    'address': '635 Phelan Ave., San Jose, CA 95112',
    'website': 'http://www.bagi.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Montalvo Art Center',
    'info': ['art', 'cultural', 'creative'],
    'address': '15400 Montalvo Rd., Saratoga, CA 95071',
    'website': 'http://montalvoarts.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth Art Foundation',
    'info': ['art', 'leadership', 'training', 'educaiton', 'youth'],
    'address': '',
    'website': 'http://youthart.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hype Baseball',
    'info': ['athletics', 'sports', 'baseball'],
    'address': '',
    'website': 'http://hypebaseball.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Luv Michael',
    'info': ['autism', 'community', 'service', 'health'],
    'address': '42 Walker Street, New York, NY 10013',
    'website': 'https://luvmichael.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hiller Aviation Museum',
    'info': ['aviation', 'museum', 'education'],
    'address': '601 Skyway Rd., San Carlos, CA 94070',
    'website': 'http://hiller.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Home Equity Plus',
    'info': ['awareness', 'health', 'equity', 'community'],
    'address': '',
    'website': 'http://healthequityplus.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Santa Theresa Little League',
    'info': ['baseball', 'athletics', 'sports'],
    'address': 'San Jose, California 95153',
    'website': 'https://www.stlittleleague.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cencal Athletics',
    'info': ['baseball', 'athletics', 'sports', 'children', 'kids'],
    'address': '1005 E Pescadero Ave, Tracy, CA 95304',
    'website': 'http://cencalathletics.com',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Bicycle Exchange',
    'info': ['bicycle', 'repairs', 'community', 'service'],
    'address': '3961 East Bayshore Road, Palo Alto, CA 94303',
    'website': 'http://bikex.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Community Cycles of California',
    'info': ['bike', 'cycle', 'bicycle', 'economic', 'community'],
    'address': '35 Wilson Ave., San Jose, CA 95126',
    'website': 'http://communitycyclesca.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Boys and Girls Clubs of Silicon Valley',
    'info': ['boys', 'girls', 'youth', 'children', 'sports', 'education'],
    'address': '518 Valley Way, Milpitas, CA 95035',
    'website': 'http://bgclub.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'YMCA Camp Campbell',
    'info': ['camp', 'athletics', 'youth', 'student', 'sports'],
    'address': '',
    'website': 'http://ymcasv.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pioneer Camp',
    'info': ['camp', 'children', 'summer'],
    'address': '942 Clearwater Lake Road, Port Sydney, Ontario P0B 1L0',
    'website': 'http://pioneercampontario.ca',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The Kings Academy Summer Camp',
    'info': ['camp', 'education', 'summer', 'tutoring'],
    'address': '562 N. Britton Avenue, Sunnyvale, CA 94085',
    'website': 'https://www.tka.org/cf_enotify/view.cfm?n=7751',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Camp Thrive',
    'info': ['camps', 'education', 'creative', 'kids', 'children'],
    'address': 'Mount Hermon, CA 95041',
    'website': 'http://campthrive.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth Science Institute',
    'info': ['camps', 'science', 'youth', 'education', 'summer', 'learning'],
    'address': '333 Blossom Hill Road, Los Gatos, CA 95032',
    'website': 'http://ysi-ca.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Leukemia and Lymphoma Society',
    'info': ['cancer', 'health', 'support', 'science', 'hospital'],
    'address': '3 International Drive, Suite 200, Rye Brook, NY 10573',
    'website': 'http://lls.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Mini Cat Town',
    'info': ['cat', 'adoption', 'rescue', 'animals', 'animal'],
    'address': '2200 Eastridge Loop, STE 1076, San Jose, CA 95122',
    'website': 'http://minicattown.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'St. Victor\'s School',
    'info': ['catholic', 'school', 'education', 'student', 'teacher'],
    'address': '3150 Sierra Road, San Jose, CA  95132',
    'website': 'http://stvictorschool.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bridge Road International Foundation',
    'info': ['chinese', 'cultural', 'education'],
    'address': '2090 Warm Springs Ct. Suit 256, Fremont, CA, 94539',
    'website': 'https://info889978.wixsite.com/bribri',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Chinese History Museum',
    'info': ['chinese', 'cultural', 'education', 'museum'],
    'address': '635 Phelan Avenue, San Jose, CA 95112',
    'website': 'http://chcp.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Boys Team Charity',
    'info': [],
    'address': '',
    'website': 'http://btcalmaden.chapterweb.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The Joy Culture Foundation',
    'info': ['chinese', 'culture', 'language', 'children'],
    'address': '934 Santa Cruz Ave Suite A, Menlo Park, CA 94025',
    'website': 'https://www.thejoyculturefoundation.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Enlighten Chinese School',
    'info': ['chinese', 'language', 'tutor', 'education'],
    'address': '1921 Clarinda Way, San Jose, CA 95124',
    'website': 'http://enlightenschool.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'IFly',
    'info': ['chinese', 'learning', 'education'],
    'address': '',
    'website': 'http://iflyyoung.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Family Giving Tree',
    'info': ['christmas', 'community', 'festival', 'poverty'],
    'address':
        'Family Giving Tree, Sobrato Center for Nonprofits, 606 Valley Way, Milpitas CA 95035',
    'website': 'http://familygivingtree.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bit By Bit Coding',
    'info': ['code', 'education', 'children', 'under represented', 'students'],
    'address': '',
    'website': 'http://bitbybitcoding.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'City of San Jose',
    'info': ['community'],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'City of Saratoga',
    'info': ['community'],
    'address': '',
    'website': 'http://saratoga.ca.us/278/Volunteer',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'JW House',
    'info': ['community', 'hospitality', 'service', 'health', 'support'],
    'address': '3850 Homestead Road, Santa Clara, CA 95051',
    'website': 'http://jwhouse.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Freedom Fest',
    'info': ['community', 'service'],
    'address': 'Morgan Hill, CA 95038',
    'website': 'https://morganhillfreedomfest.com/volunteer',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Grace Solutions',
    'info': ['community', 'service'],
    'address': '484 E. San Fernando St., San Jose, Ca. 95112',
    'website': 'https://www.gracesolutions.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saratoga Library',
    'info': ['community', 'service'],
    'address': '13650 Saratoga Ave, Saratoga, CA 95070',
    'website': 'http://sccl.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth Action Council Morgan Hill',
    'info': ['community', 'service'],
    'address': '17575 Peak Avenue, Morgan Hill, CA 95037',
    'website': 'http://morgan-hill.ca.gov/273/Youth-Action-Council',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Love To Share Foundation',
    'info': ['community', 'service', 'care'],
    'address': '3363 Bel Mira Way, San Jose, CA 95135',
    'website': 'https://lovetosharefoundation.org/',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth Leadership Coalition District 10',
    'info': ['community', 'service', 'government', 'youth'],
    'address': '',
    'website': 'http://d10advisorycouncil.wixsite.com/district10yac',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth Leadership Coalition District 5',
    'info': ['community', 'service', 'government', 'youth'],
    'address': '200 E. Santa Clara St., San Jose, Ca 95113',
    'website':
        'https://www.sanjoseca.gov/your-government/departments-offices/mayor-and-city-council/district-5/meet-the-d5-team',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'STAND 4 Inc.',
    'info': ['community', 'service', 'injustice', 'youth', 'teens'],
    'address': '',
    'website': 'http://fightthehateglobal.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hope Horizon',
    'info': ['community', 'service', 'leadership'],
    'address': '1001 Beech St, East Palo Alto, CA 94303',
    'website': 'http://hopehorizonepa.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'LOV League of Volunteers',
    'info': ['community', 'service', 'poverty', 'kids', 'food'],
    'address': 'Newark, CA 94560',
    'website': 'http://lov.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bill Wilson Center',
    'info': ['counseling', 'housing', 'education', 'advocacy.'],
    'address': '3490 The Alameda, Santa Clara, CA 95050',
    'website': 'http://billwilsoncenter.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Color A Smile',
    'info': [],
    'address': '',
    'website': 'http://colorasmile.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'South Bay Clean Creeks Coalition',
    'info': ['creeks', 'river', 'nature', 'outdoors', 'cleanup'],
    'address': '',
    'website': 'https://sbcleancreeks.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Mosaic America',
    'info': ['culture', 'community', 'service', 'local', 'arts'],
    'address': '',
    'website': 'http://mosaicamerica.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Dance Theater',
    'info': ['dance', 'culture', 'arts', 'theater'],
    'address': '1756 Junction Ave. Suite E, San Jose, CA 95112',
    'website': 'http://Sjdt.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Best Buddies',
    'info': ['disabilities', 'children', 'youth'],
    'address': '100 Southeast Second St, Suite 2200, Miami, FL 33131',
    'website': 'http://bestbuddies.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Artistic Swimming for Athletes with Disabilities',
    'info': ['disability', 'swimming', 'athletics', 'sports'],
    'address': '1484 Pollard Rd #221, Los Gatos, CA 95032',
    'website': 'https://www.artisticswimawd.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Doggie Protective Services (DPS)',
    'info': ['dog', 'adoption', 'rescue', 'animal'],
    'address': '809 San Antonio Rd #8, Palo Alto, CA 94303',
    'website': 'https://dpsrescue.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Jake\'s Wish Rescue',
    'info': ['dog', 'adoption', 'rescue', 'animal'],
    'address': 'San Martin, CA 95046',
    'website': 'http://jakeswishrescue.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Almaden Country Day School',
    'info': ['education'],
    'address': '6835 Trinidad Drive, San Jose, CA 95120',
    'website': 'http://almadencountrydayschool.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hacienda Elementary',
    'info': ['education', 'children', 'kids', 'students'],
    'address':
        'Hacienda Science/Environmental Magnet, 1290 Kimberly Drive, San Jose, CA 95118',
    'website': 'http://hacienda.sjusd.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Shin Shin Educational Foundation',
    'info': ['education', 'china', 'chinese', 'children', 'kids'],
    'address': '',
    'website': 'http://shinshinfoundation.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Leland Bridge at Leland High School',
    'info': ['education', 'chinese'],
    'address': '',
    'website': 'https://www.lelandbridge.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Wisdom Culture Education Organization',
    'info': ['education', 'chinese', 'culture', 'youth'],
    'address': '186 E. Gish Rd., San Jose, CA 95112',
    'website': 'http://wceo.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'American Chinese School',
    'info': ['education', 'chinese', 'language'],
    'address': '5259 Amberwood Dr, Fremont, CA 94555',
    'website': 'http://achineseschool.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Neighborhood Christian Schools',
    'info': ['education', 'christian', 'students', 'kids', 'children'],
    'address': '16010 Jackson Oaks Dr, Morgan Hill, CA 95037',
    'website': 'http://myncs.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sparkhub Foundation',
    'info': ['education', 'community', 'service'],
    'address': '',
    'website': 'http://sparkhubfoundation.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Meaningful Teens Program (Project Speak Together)',
    'info': ['education', 'language', 'math', 'students'],
    'address': '',
    'website': 'https://projectspeaktogether.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Parent Participating Preschool',
    'info': ['education', 'parents', 'school', 'preschool'],
    'address': '2180 Radio Ave, San Jose, CA 95125',
    'website': 'http://sanjoseparents.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Los Gatos Christian School',
    'info': ['education', 'school', 'students'],
    'address': '16845 Hicks Road, Los Gatos, California 95032',
    'website': 'http://lgcs.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Charter School of Morgan Hill',
    'info': ['education', 'school', 'students', 'kids'],
    'address': '9530 Monterey Rd., Morgan Hill, CA 95037',
    'website': 'http://csmh.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Green Scholars Program',
    'info': [],
    'address': '',
    'website': 'http://greenescholars.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'AiducateNow',
    'info': ['education', 'stem', 'india'],
    'address': '',
    'website': 'http://aiducatenow.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sillicon Valley Youth',
    'info': ['education', 'students', 'youth', 'underpreveliged'],
    'address': '',
    'website': 'https://www.siliconvalleyyouth.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bay Area Tutors',
    'info': ['education', 'tutor', 'children', 'students'],
    'address': '',
    'website': 'http://bayareatutor.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Breakthrough Tutoring Silicon Valley',
    'info': ['education', 'tutor', 'children', 'students', 'low-income'],
    'address': '1635 PARK AVE #138, SAN JOSE, CA 95126',
    'website': 'http://www.breakthroughsv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Catepillar Academy',
    'info': ['education', 'tutor', 'students', 'kids'],
    'address': '',
    'website': 'http://caterpillaracademy.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Happy Hollow (City of San Jose)',
    'info': [],
    'address': '',
    'website': 'http://happyhollow.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Evergreen Initiative',
    'info': ['education', 'tutor', 'students', 'kids'],
    'address': '',
    'website': 'http://evergreeninitiative.weebly.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Gyandeep Growth Foundation',
    'info': ['education', 'under previleged', 'children'],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Paradise Engineering Academy',
    'info': ['engineering', 'science', 'stem', 'students', 'education'],
    'address': '1400 La Crosse Dr., Morgan Hill, CA 95037',
    'website': 'http://paradise.mhusd.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pacific E-Sports League',
    'info': ['esports', 'gaming', 'videogames'],
    'address': '',
    'website': 'http://pacificesports.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Center For Farmworker Families',
    'info': ['farming', 'mexico', 'support'],
    'address': 'Felton, CA 95018',
    'website': 'http://farmworkerfamily.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Octavia\'s Kitchen',
    'info': ['food', 'community', 'service', 'kitchen'],
    'address': 'St James Park, San Jose, CA 95112',
    'website': 'http://octaviaskitchen.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'La Mesa Verde',
    'info': ['food', 'health', 'community', 'service', 'gardening'],
    'address': '1381 S First St, San Jose, CA 95110',
    'website': 'https://www.lamesaverdeshcs.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hope Hearted Volunteers',
    'info': ['food', 'homeless', 'low income'],
    'address': '',
    'website': 'http://hopeheartedvolunteers.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Street Life Ministries',
    'info': ['food', 'homeless', 'shelter', 'community', 'service'],
    'address': '2890 Middlefield Road, Palo Alto, CA 94306',
    'website': 'http://streetlifeministries.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Second Harvest Food Bank',
    'info': ['food', 'homelessness', 'poor', 'community', 'service'],
    'address': '750 Curtner Avenue, San Jose, CA 95125',
    'website': 'http://shfb.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hongyun Art Foundation',
    'info': [],
    'address': '',
    'website': 'http://hyafound.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Martha\'s Kitchen',
    'info': ['food', 'poverty', 'homeless', 'community', 'service'],
    'address': '311 Willow St, San Jose, CA 95110',
    'website': 'http://marthas-kitchen.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pop Warner League',
    'info': ['football', 'cheerleading', 'sports', 'athletics'],
    'address': '16500 Condit Road, Morgan Hill , CA 95037',
    'website': 'http://morganhillraiders.com',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Francaise Silicon Valley',
    'info': ['french', 'language', 'education', 'classes'],
    'address': '14107 Winchester Blvd, Suite T, Los Gatos, CA 95032',
    'website': 'http://www.afscv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Taylor Street Farms',
    'info': ['garden', 'farm', 'outdoors', 'nature', 'food'],
    'address': '200 W Taylor St. San Jose, CA 95110',
    'website': 'http://garden2tablesv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Heritage Rose Garden at Guadalupe Park',
    'info': ['gardening', 'nature', 'plant'],
    'address': '438 Coleman Ave, San Jose, CA 95110',
    'website': 'http://heritageroses.us',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Indian Health Center of Santa Clara Valley',
    'info': [],
    'address': '',
    'website': 'http://indianhealthcenter.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Girls On The Run',
    'info': ['girls', 'children', 'sports', 'athletics'],
    'address': 'LOS GATOS, CA 95031',
    'website': 'http://gotrsv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Foundation-US Kids Golf',
    'info': ['golf', 'atheltics', 'sports'],
    'address': '',
    'website': 'https://www.uskidsgolf.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'First Tea of Sillicon Valley',
    'info': ['golf', 'low income', 'sports', 'atheltics'],
    'address': '2797 Park Avenue , Suite 205, Santa Clara, CA, 95050',
    'website': 'http://firstteesiliconvalley.org/about/volunteer',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Peninsula Guitar Series',
    'info': ['guitar', 'classical music', 'performance', 'cultural', 'arts'],
    'address': '',
    'website': 'http://peninsulaguitar.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Onehacks',
    'info': ['hackathon', 'coding', 'stem', 'science', 'code', 'youth'],
    'address': '',
    'website': 'http://onehacks.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Francisco Calheat Team Handball Club',
    'info': ['handball', 'sports', 'athletics'],
    'address': '',
    'website': 'http://calheat.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Kaiser Permanente',
    'info': [],
    'address': '',
    'website': 'http://kp.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cure A Little Heart Foundation',
    'info': ['health', 'children', 'medical'],
    'address': '4779 S, 7th Street, Terre Haute, IN 47802',
    'website': 'http://hrudaya.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Coach Art',
    'info': ['health', 'coach', 'mentor', 'art', 'creative', 'student', 'kids'],
    'address': '445 S. Figueroa St. Suite 3100, Los Angeles, CA 90071',
    'website': 'http://coachart.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Health Trust',
    'info': ['health', 'community', 'service'],
    'address': '3180 Newberry Dr., Suite 200, San Jose, CA 95118',
    'website': 'http://healthtrust.org/volunteer',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Walk For Life WC',
    'info': ['health', 'community', 'service'],
    'address': 'San Francisco, CA  94122',
    'website': 'https://www.walkforlifewc.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Breathe California of the Bay Area',
    'info': ['health', 'diseases', 'illness'],
    'address': '1469 Park Avenue, San Jose, CA 95126',
    'website': 'https://lungsrus.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Africa Cries Out',
    'info': ['health', 'education'],
    'address': '1171 East Putnam Ave, Riverside, CT 06878 USA',
    'website': 'http://africacriesout.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Healing Grove Medical Center',
    'info': ['health', 'healthcare', 'medical'],
    'address': '226 W. Alma Ave, Suite 10, San Jose, CA 95110',
    'website': 'https://healinggrove.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Healthier Kids Foundation',
    'info': ['health', 'kids', 'community', 'service'],
    'address': '4040 Moorpark Ave, Suite 100, San Jose, CA 95117',
    'website': 'http://hkidsf.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'American Foundation for Suicide Prevention',
    'info': ['health', 'mental health', 'suicide', 'emotional health'],
    'address': '2635 Napa St #3557, Vallejo, CA 94590',
    'website': 'http://afsp.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pragnya',
    'info': ['health', 'neuro', 'special needs', 'diversity', 'children'],
    'address': '1917 Concourse Drv, San Jose, CA 95131',
    'website': 'https://www.pragnya.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Real Options',
    'info': ['healthcare', 'health', 'community', 'hospital', 'clinic'],
    'address': '1671 The Alameda, Suite 101, San Jose, CA 95126',
    'website': 'http://friendsofrealoptions.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'US Department of Veteran Affairs',
    'info': ['healthcare', 'hospital', 'clinic', 'veteran'],
    'address': '795 Willow Road, Menlo Park, CA 94025',
    'website': 'http://va.gov/palo-alto-health-care',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Tri Valley Hockey Association Inc.',
    'info': ['hockey', 'sports', 'athletics'],
    'address': 'Dublin, CA 94568',
    'website': 'http://trivalleyminorhockey.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Habitat for Humanity Bay Area',
    'info': ['home', 'community', 'construction', 'service'],
    'address': '513 Valley Way, Milpitas, CA 95035',
    'website': 'http://habitatebsv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Agape Silicon Valley',
    'info': ['homeless', 'hunger'],
    'address': '',
    'website': 'http://agapesiliconvalley.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Seva Commons Foundation',
    'info': ['homelessness', 'food', 'hungry', 'community', 'service'],
    'address': '',
    'website': 'http://sevacommons.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Help4Hope',
    'info': ['homelessness', 'food', 'poor', 'health'],
    'address': '',
    'website': 'http://help4hope.godaddysites.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sleeping Bags for Homeless',
    'info': ['homelessness', 'poverty', 'community', 'service'],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Head Heart and Hands',
    'info': ['homeschooling', 'education', 'kids', 'children', 'students'],
    'address': '',
    'website': 'https://www.head-heart-hands.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Divine Equestrian Therapy',
    'info': ['horse', 'riding'],
    'address': '',
    'website': 'http://divineequinetherapy.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cevalo Riding Academy',
    'info': ['horse', 'riding', 'kids', 'animals', 'students'],
    'address': 'Los Gatos, CA 95032',
    'website': 'https://www.cevaloridingacademy.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Dream Power',
    'info': ['horse', 'riding', 'therapy', 'health'],
    'address': '4478 GA-352, Box Springs, GA 31801',
    'website': 'https://dreampowertherapy.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'El Camino Hospital',
    'info': ['hospital', 'medicine', 'health'],
    'address':
        'El Camino Health, Auxiliary & Volunteer Services, Willow Pavilion, 2nd Floor, 2500 Grant Road, Mountain View, CA 94040',
    'website': 'http://elcaminohealth.org/volunteer/auxiliary',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Morgan Hill Historical Society',
    'info': [],
    'address': '',
    'website': 'http://morganhillhistoricalsociety.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Live Moves',
    'info': ['housing', 'poverty', 'homeless', 'community', 'service'],
    'address': '2550 Great America Way, Suite 201, Santa Clara, CA 95054',
    'website': 'http://lifemoves.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hunger At Home',
    'info': ['hunger', 'food', 'low income', 'community', 'service'],
    'address': '1560 Berger Drive, San Jose, CA 95112',
    'website': 'http://hungerathome.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'West Valley Community Services',
    'info': ['hunger', 'food', 'low income', 'poverty'],
    'address': '10104 Vista Dr, Cupertino, CA 95014',
    'website': 'http://wvcommunityservices.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'St. Joseph\'s Family Center',
    'info': ['hunger', 'homelessness', 'community', 'service'],
    'address': '7950 Church Street, Suite A, Gilroy, CA 95020',
    'website': 'https://stjosephsgilroy.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'AIA Association of Indo Americans',
    'info': ['india', 'culture'],
    'address': '',
    'website': 'http://aiaevents.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Art of Living',
    'info': ['india', 'meditation', 'cultural', 'yoga'],
    'address': '',
    'website': 'http://artofliving.org/us-en',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Tamil Nadu Foundation',
    'info': ['india', 'youth', 'women', 'health', 'rural'],
    'address': '7409 Green Hill Drive, Macungie, PA 18062',
    'website': 'http://tnfusa.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hamsanada',
    'info': ['indian', 'classical Music', 'music', 'arts', 'creative'],
    'address': '',
    'website':
        'https://www.facebook.com/groups/413068226109364/discussion/preview',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Nikkei Matsuri Foundation',
    'info': ['japan', 'japanese', 'cultural', 'community', 'service'],
    'address': '640 N. 5th St., San Jose, CA 95112',
    'website': 'http://nikkeimatsuri.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Jewish Family Services of Silicon Valley',
    'info': ['jewish', 'family', 'adults', 'children'],
    'address': '14855 Oka Road, Suite 202, Los Gatos CA 95032',
    'website': 'http://jfssv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Korean School',
    'info': ['korean', 'education', 'language'],
    'address': '10100 Finch Ave, Cupertino, CA 95014',
    'website': 'http://svks.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Tomahawks Lacrosse',
    'info': ['lacrosse', 'sports', 'athletics', 'camps'],
    'address': '1955 Tasso Street. Palo Alto, CA 94301',
    'website': 'http://tomahawkslacrosse.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hello Languages',
    'info': ['languages', 'education', 'kids', 'children', 'students'],
    'address': '',
    'website': 'http://hellolanguages.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'White Stag Leadership Development Academy',
    'info': ['leadership', 'youth'],
    'address': '33 Soledad Drive, Monterey, CA 93940',
    'website': 'http://whitestagmonterey.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Our City Forest',
    'info': [],
    'address': '',
    'website': 'http://ourcityforest.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'PALS Program',
    'info': ['legal', 'lawyers', 'mentorship', 'mentor', 'education'],
    'address': '',
    'website': 'http://palsprogram.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Public Libraries- Edenvale Branch',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '101 Branham Ln E, San Jose, CA 95111',
    'website': 'http://sjlibrary.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Public Library- Almaden Branch',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '6445 Camden Ave, San Jose, CA 95120',
    'website': 'http://sjpl.org/teensreach',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Public Library- Cambrian Branch',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '1780 Hillsdale Ave, San Jose, CA 95124',
    'website': 'http://sjpl.org/cambrian',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Public Library- Evergreen',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '2635 Aborn Rd, San Jose, CA 95121',
    'website': 'http://sjpl.org/evergreen',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Public Library- Santa Theresa',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '290 International Cir, San Jose, CA 95119',
    'website': 'http://sjpl.org/santa-teresa',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saratoga Senior Center',
    'info': ['library', 'education', 'reading', 'books', 'tutoring'],
    'address': '',
    'website': 'http://sascc.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Benefits Foundation',
    'info': ['martial arts', 'children', 'underprivileged'],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Student Corps',
    'info': ['math', 'stem', 'youth', 'students'],
    'address': '',
    'website': 'http://vcsstudentcorps.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'U Channel Foundation',
    'info': ['media', 'chinese'],
    'address': '1177 Laurelwood Rd., Santa Clara, CA 95054',
    'website': 'http://uchanneltv.us/english.html',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'RAFT',
    'info': [],
    'address': '',
    'website': 'http://raft.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Good Samaritan Hospital',
    'info': ['medical', 'health', 'science'],
    'address': '2425 Samaritan Dr, San Jose, CA 95124',
    'website': 'https://goodsamsanjose.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Regional Medical Center San Jose',
    'info': ['medical', 'hospital', 'health', 'science', 'stem'],
    'address':
        'Regional Medical Center of San Jose, 225 North Jackson Ave, San Jose CA 95116',
    'website':
        'https://regionalmedicalsanjose.com/community/junior-volunteer-application.dot',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Meet The Challenge',
    'info': ['ministry', 'faithbased', 'community', 'homeless'],
    'address': 'San Jose, CA 95153',
    'website': 'http://meetthechallenge.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Lorenzo Vally Museum',
    'info': ['museum', 'education', 'arts', 'culture'],
    'address': '12547 Highway 9, Boulder Creek, CA 95006',
    'website': 'http://slvmuseum.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Santa Theresa Music and Arts',
    'info': ['music', 'arts', 'culture'],
    'address': '',
    'website': 'https://santateresamusic.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Academy of Music and Arts for Special Education',
    'info': ['music', 'arts', 'education', 'creative'],
    'address':
        'Valley Church of Cupertino, 10885 N Stelling Rd., Cupertino, CA 95014',
    'website': 'http://amaseus.org/about-us.html',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Music Students Servant League',
    'info': ['music', 'arts', 'performance', 'cultural'],
    'address': '',
    'website':
        'http://mtacsacb.org/student-programs/music-student-service-league',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Eternity Band',
    'info': ['music', 'band', 'art', 'community'],
    'address': '',
    'website': 'http://eternityband.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Crescendo Connect',
    'info': ['music', 'creative', 'art', 'family', 'community'],
    'address': '',
    'website': 'http://crescendoconnect.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'California School of Music and Art',
    'info': ['music', 'creative', 'art', 'students'],
    'address': 'Finn Center, 230 San Antonio Circle, Mountain View, CA 94040',
    'website': 'http://arts4all.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'MusicNBrain',
    'info': ['music', 'performance', 'students', 'children', 'kids', 'art'],
    'address': '',
    'website': 'http://musicnbrain.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Almaden Youth Musician',
    'info': ['music', 'seniors', 'arts'],
    'address': '',
    'website': 'http://almadenyouthmusicians.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Love Through Music',
    'info': ['music', 'undeserved', 'art', 'creative', 'community'],
    'address': 'Arcadia, CA 91077',
    'website': 'https://www.lovethrough-music.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hakone Gardens Estate And Gardens',
    'info': ['nature', 'garden', 'japanese', 'plants'],
    'address': '21000 Big Basin Way, Saratoga, CA  95070',
    'website': 'http://hakone.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Creek Connections Action Group',
    'info': ['nature', 'outdoor', 'community'],
    'address': '',
    'website': 'http://cleanacreek.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'California Native Plant Society',
    'info': ['nature', 'plant'],
    'address': '3921 East Bayshore Road, Suite 205, Palo Alto, CA 94303',
    'website': 'http://cnps-scv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'With A Thousand Crames',
    'info': ['origanmi', 'happines', 'culture'],
    'address': '',
    'website': 'http://withathousandcranes.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Aubri Brown club',
    'info': ['parents', 'care'],
    'address': '9800 Lantz Drive, Morgan Hill, CA 95037',
    'website': 'http://theaubribrownclub.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Word of Grace',
    'info': ['parents', 'enrichment', 'education', 'youth', 'language'],
    'address': '2360 McLaughlin Ave, San Jose, CA 95122',
    'website': 'http://wordofgraceschool.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'East Bay Park Regional District',
    'info': ['park', 'nature', 'community'],
    'address': '2950 Peralta Oaks Court, Oakland, CA 94605',
    'website': 'http://ebparks.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Santa Clara County Parks',
    'info': ['park', 'nature', 'outdoors', 'adventure'],
    'address': '',
    'website': 'https://parks.sccgov.org/home',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sunnyvale Explorer Program',
    'info': ['police', 'training', 'youth'],
    'address': '456 W. Olive Ave., Sunnyvale, CA 94086',
    'website':
        'http://sunnyvale.ca.gov/your-government/departments/public-safety/public-safety-services/community-programs',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Portuguese Order of the Holy Ghost Lodge',
    'info': ['portugal', 'portuguese', 'community', 'service', 'cultural'],
    'address': '',
    'website': 'https://www.facebook.com/sfv.lodge?mibextid=LQQJ4d',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'City Team',
    'info': ['poverty', 'community', 'homelessness'],
    'address': '2306 Zanker Rd., San Jose, CA 95131',
    'website': 'http://cityteam.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Downtown Streets Team',
    'info': ['poverty', 'community', 'homelessness'],
    'address': '1671 The Alameda #301, San Jose, CA 95126',
    'website': 'http://streetsteam.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Family Supportive Housing',
    'info': ['poverty', 'community', 'homelessness'],
    'address': '692 N. King Road, San Jose, CA 95133',
    'website': 'http://familysupportivehousing.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sacred Heart Community Services',
    'info': ['poverty', 'community', 'support'],
    'address': '1381 South First Street, San Jose, CA 95110',
    'website': 'https://www.sacredheartcs.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Salvation Army',
    'info': ['poverty', 'homelessness', 'community', 'support', 'outreach'],
    'address': '',
    'website': 'https://www.salvationarmy.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Reading Partners',
    'info': ['reading', 'literacy', 'low income under preveliged', 'children'],
    'address': '638 3rd Street, Oakland, CA 94607',
    'website': 'http://readingpartners.org/location/silicon-valley',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Rescue The Underdog',
    'info': ['rescue', 'dog', 'adoption', 'animals'],
    'address': '',
    'website': 'http://rescuetheunderdog.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Robotics Education & Competition Foundation',
    'info': ['robotics', 'VEX', 'science', 'technology', 'stem'],
    'address': '',
    'website': 'http://roboticseducation.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Christian School',
    'info': ['school', 'education', 'christian'],
    'address': '1300 Sheffield Avenue, Campbell, CA, 95008',
    'website': 'http://sjchristian.org/giving/walk-a-thon.cfm',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'One People On Cosmos',
    'info': ['science', 'astronomy', 'stem'],
    'address': '',
    'website': 'http://onepeopleonecosmos.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Learning Landmark',
    'info': ['science', 'tech', 'stem', 'students', 'kids', 'children'],
    'address': '',
    'website': 'http://learninglandmark.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sourcewise',
    'info': ['seniors', 'caretakers', 'support', 'community'],
    'address': '3100 De La Cruz Blvd, Suite 310, Santa Clara, CA 95054',
    'website': 'http://mysourcewise.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Rossinca Heritage School',
    'info': ['slavic', 'language', 'literacy', 'community', 'support'],
    'address': '2095 Park Avenue, San Jose, CA 95126',
    'website': 'http://rossinca.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pajama Program',
    'info': ['sleep', 'kids', 'children', 'support'],
    'address': '171 Madison Avenue, Suite 1409, New York, NY 10016',
    'website': 'https://pajamaprogram.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Lady Sharks',
    'info': ['softball', 'baseball', 'girls', 'athletics', 'sports'],
    'address': '2001 Cottle Rd., San Jose, CA 95125',
    'website': 'http://ladysharksfastpitch.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Life Services Alternatives',
    'info': ['special needs', 'adults', 'health', 'disability'],
    'address': '260 W Hamilton Ave, Campbell, CA 95008',
    'website': 'http://lsahomes.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'FCSN (Friends of Children with Special Needs)',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '2300 Peralta Blvd., Fremont, CA 94536',
    'website': 'http://fcsn1996.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Home of Hope',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '1177 California Street #1424, San Francisco, CA 94108',
    'website': 'http://hohinc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Inclusive World',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '106 S Park Victoria Dr, Milpitas, CA 95035',
    'website': 'https://inclusiveworld.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'South Valley Fish Food Pantry',
    'info': [],
    'address': '',
    'website': 'http://www.svfish.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'InFUSE',
    'info': ['special needs', 'disability', 'children', 'kids', 'community'],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Warpitect',
    'info': ['special needs', 'education'],
    'address': '',
    'website': 'https://www.warpitect.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Science of Spirituality',
    'info': ['spiritual', 'sikh', 'indian', 'community', 'service'],
    'address': '4105 Naperville Road, Lisle, IL 60532',
    'website': 'http://sos.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'BAWSI (Bay Area Womens Sports Initiative)',
    'info': ['sports', 'athletics', 'girls', 'children'],
    'address': '1922 The Alameda, Suite 420, San Jose, CA 95126',
    'website': 'http://bawsi.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'American Junior Golf Association',
    'info': ['sports', 'athletics', 'golf'],
    'address': '1980 Sports Club Drive, Braselton, GA 30517',
    'website': 'http://ajga.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Infinity Sports Club',
    'info': ['sports', 'camps', 'athletics', 'hockey', 'soccer'],
    'address': '',
    'website': 'http://Infinitysportsclub.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bay Area Chess Association',
    'info': ['sports', 'chess'],
    'address': '2050 Concourse Drive #42, San Jose, CA 95131',
    'website': 'https://bayareachess.com/index',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Almaden Riptide Swim',
    'info': ['sports', 'swimming', 'athletics'],
    'address': '1079 Shadow Brook Drive, San Jose, CA 95120',
    'website': 'https://www.almadenriptides.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Chabot Space and Science Museum',
    'info': ['stem', 'science', 'space', 'educaiton'],
    'address': '10000 Skyline Blvd., Oakland, California 94619',
    'website': 'http://chabotspace.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Santa Clara Sister Cities',
    'info': ['students', 'exchange program', 'education', 'leadership'],
    'address': 'Santa Clara, CA 95052',
    'website': 'http://santaclarasistercities.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Nor Cal Aquatics',
    'info': ['swimming', 'aquatics', 'athletics', 'sports', 'water polo'],
    'address': '',
    'website': 'https://www.norcal-aquatics.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Quicksilver Swimming Program',
    'info': ['swimming', 'athletics', 'students', 'sports', 'swim'],
    'address': '',
    'website': 'http://teamunify.com/team/pcqs/page/home',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Encore Swim Team',
    'info': ['swimming', 'swim', 'sports', 'athletics'],
    'address': '8127 Mesa Drive, Suite B206-223, Austin, Texas 78759',
    'website': 'http://hencoreswim.swimtopia.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Table Tennis America Foundation',
    'info': ['table tennis', 'sports', 'athletics'],
    'address': '42670 Albrae St, Fremont, CA 94538, USA',
    'website': 'http://ttamerica.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Connexpedition',
    'info': ['taiwan', 'tutor', 'english', 'education', 'chinese'],
    'address': '',
    'website': 'http://connexpedition.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The Tech Interactive',
    'info': ['technology', 'stem', 'science', 'maths', 'camps', 'museum'],
    'address': '201 S. Market St., San Jose, CA 95113',
    'website': 'http://thetech.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bright Future Teens',
    'info': ['teens', 'education', 'leadership'],
    'address': '',
    'website': 'http://brightfutureteen.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The Young Expressionists- VCHS Student Organization',
    'info': [],
    'address': '',
    'website': 'http://theyoungexpressionists.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Teens Volunteer',
    'info': ['teens', 'foodbank', 'education', 'books', 'library'],
    'address': '',
    'website': 'http://teensvolunteer.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Neighborhood Teens',
    'info': ['teens', 'students', 'community', 'service'],
    'address': '',
    'website': 'http://www.nteens.net/home',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'BATA (Bay Area Telugu Association)',
    'info': ['telegu', 'culture', 'india'],
    'address': '39120 Argonaut Way # 555,Fremont CA 94538',
    'website': 'http://bata.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'WETA (Women\'s Empowerment Telugu Association)',
    'info': ['telegu', 'india', 'women', 'empowerment'],
    'address': '1114 W 6th Street, Suite #110, Hanford, CA 93230',
    'website': 'http://wetaglobal.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Our City Forest',
    'info': ['trees', 'nature', 'plant', 'forest', 'community', 'service'],
    'address': '1195 Clark St. San Jose, CA 95125',
    'website': 'http://ourcityforest.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Triathalon Event',
    'info': ['triathalon', 'running', 'sports', 'athletics'],
    'address': '',
    'website':
        'http://runsignup.com/Race/Volunteer/CA/Cupertino/SiliconValleyKidsTriathlon',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Flowing Waters Foundation',
    'info': ['tutor', 'education', 'children', 'under previleged ML'],
    'address': '',
    'website': 'http://flowingwatersfoundation.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Engin',
    'info': ['ukraine', 'education', 'english', 'communicate', 'language'],
    'address': '',
    'website': 'http://enginprogram.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sunday Friends',
    'info': ['underserved', 'health', 'food', 'education', 'poverty'],
    'address': '645 Wool Creek Drive, 2nd Floor Suite A, San Jose, CA 95112',
    'website': 'http://Sundayfriends.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Valle Verde',
    'info': ['vegetable', 'nature', 'garden', 'environment', 'food'],
    'address': '691 W San Carlos St., San Jose, CA 95126',
    'website': 'http://valleyverde.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Vietnamese Christian Restoration Ministry',
    'info': ['veitnamese', 'vietnam', 'community', 'service'],
    'address': 'Dallas, TX 75381',
    'website': 'http://vcrministry.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose VA Clinic',
    'info': ['veteran', 'community', 'support'],
    'address': '5855 Silver Creek Valley Place, San Jose, CA 95138-1059',
    'website':
        'https://www.va.gov/palo-alto-health-care/locations/san-jose-va-clinic/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Vietnamese Running Club (SJVRC)',
    'info': ['vietnam', 'children', 'community', 'support'],
    'address': '2266 Senter Rd, Suite 146, San Jose, CA 95112',
    'website': 'http://sjvrc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name':
        'NCAVAD, Inc. (North California Association of Vietnamese American Dentists)',
    'info': ['vietnamese', 'dentist', 'health', 'doctor', 'community'],
    'address': '',
    'website': 'http://ncavad.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'United States Youth Volleyball League',
    'info': ['volleyball', 'athletics', 'sports', 'kids'],
    'address': '2771 Plaza Del Amo, Suite 808, Torrance, CA 90503',
    'website': 'http://usyvl.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Express Aquatics',
    'info': ['water polo', 'swimming', 'athletics', 'aquatics', 'sports'],
    'address': '​18900 Prospect Road, Saratoga, CA​ 95070',
    'website': 'http://www.sanjoseexpress.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Outlaws',
    'info': ['waterpolo', 'swimming', 'athletics', 'sports'],
    'address': '100 Skyway Dr, San Jose, CA 95111',
    'website': 'http://svoutlaws.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Lindsay Wildlife Center',
    'info': ['wildlife', 'nature', 'animal'],
    'address': '1931 First Avenue, Walnut Creek, CA 94597',
    'website': 'http://lindsaywildlife.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Wildlife Center of Silicon Valley',
    'info': ['wildlife', 'nature', 'animal', 'nature'],
    'address': '3027 Penitencia Creek Rd, San Jose, CA 95132',
    'website': 'http://wcsv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cheyenne River Youth Project',
    'info': ['youth,'],
    'address': '702 4th Street, Eagle Butte, SD 57625',
    'website': 'http://lakotayouth.org',
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
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
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth4good',
    'info': ['youth', 'community', 'service', 'leadership', 'food', 'hunger'],
    'address': '',
    'website': 'http://youth4good.us',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Empower Excel',
    'info': ['youth', 'kids', 'community'],
    'address': 'San Jose, CA 95151',
    'website': 'http://empowerexcel.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth Priority',
    'info': ['youth', 'sick', 'health', 'fundraising'],
    'address': '',
    'website': 'https://youthpriority.mystrikingly.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'STAR Arts',
    'info': ['youth', 'teens', 'arts', 'music', 'cultural', 'theater'],
    'address': '7393 Monterey Road, Gilroy, CA. 95020',
    'website': 'http://starartseducation.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'American Cancer Society Discovery Shop',
    'info': [],
    'address': '1103 Branham Lane, San Jose, CA 95118',
    'website':
        'https://www.cancer.org/donate/discovery-shops-national/california-discovery-shops/san-jose.html',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'American Chinese Youth Performing Arts Foundation',
    'info': [],
    'address': '967 Hall St, San Carlos, CA 94070',
    'website':
        'http://californiaexplore.com/company/04287985/american-chinese-youth-performing-art-foundation',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bret Harte Middle School Programs',
    'info': [],
    'address': '7050 Bret Harte Drive, San José, CA 95120',
    'website': 'http://bretharte.sjusd.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Just Serve',
    'info': [],
    'address': '',
    'website': 'https://www.justserve.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Merryhill Milpitas Middle School',
    'info': [],
    'address': '1500 Yosemite Dr, Milpitas, CA 95035',
    'website': 'http://merryhillschool.com/elementary/san-jose/milpitas',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Morgan Hills Aquatic Center',
    'info': [],
    'address': '17575 Peak Avenue, Morgan Hill, CA 95037',
    'website': 'http://morgan-hill.ca.gov/189/Aquatics-Center-AC',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'PGA Jr. Foundation',
    'info': [],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Quaran Tutors',
    'info': [],
    'address': '',
    'website': 'http://quarantutors.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sky Ensemble',
    'info': [],
    'address': '',
    'website': 'http://skyensemble.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Smile CARD',
    'info': [],
    'address': '',
    'website': 'https://www.smilecard.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Special Olympics',
    'info': [],
    'address': '3480 Buskirk Ave #340, Pleasant Hill, CA 94523',
    'website': 'http://sonc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Starting Arts',
    'info': [],
    'address': '525 Parrott St, San Jose CA 95112',
    'website': 'http://startingarts.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Tian Mu',
    'info': [],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Tzu Chi',
    'info': [],
    'address': '',
    'website': 'http://tzuchi.us',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'UC Master Gardeners, Santa Clara County',
    'info': [],
    'address': '1553 Berger Drive, San Jose, CA 95112',
    'website': 'http://mgsantaclara.ucanr.edu',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Valley Splash',
    'info': [],
    'address': '',
    'website': 'http://www.teamunify.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Yew Chung International School',
    'info': [],
    'address': '310 Easy Street, Mountain View, CA 94043',
    'website': 'http://ycis-sv.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Youth4Difference',
    'info': [],
    'address': '',
    'website': '',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': '3 Crosses',
    'info': ['Church'],
    'address': '',
    'website': 'https://3crosses.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Abounding Grace Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://nowebsite.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Abundant Life Assemply of God (Cupertino)',
    'info': ['Church'],
    'address': '',
    'website': 'https://alagonline.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Abundant Life Christian Fellowship (Palo Alto)',
    'info': ['Church'],
    'address': '',
    'website': 'https://alcf.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Advent Lutheran',
    'info': ['Church'],
    'address': '',
    'website': 'https://advent-lutheran.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Afghan American Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.afghanamericanchurch.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Almaden Hills United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.almadenhillsumc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'AME Zion Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://universityamez.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Antiochian Orthodox Church of the Redeemer',
    'info': ['Church'],
    'address': '',
    'website': 'https://orthodoxredeemer.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Apostles Lutheran School and Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://apostles-lutheran.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Ark Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://arkbaptistchurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Assyrian Evangelical Church of San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://aecsj.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Assyrian Pentecostal Church of San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://assyrianfaith.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Awakening Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://awakeningchurch.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bernal Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://bernal.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Berryessa Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sanjosebac.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bethany Evangelical Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://bethanysj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bethel Church (Children\'s Ministry)',
    'info': ['Church'],
    'address': '',
    'website': 'https://bethel.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bethel Korean United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://bethelkumc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bethel Lutheran Church Cupertino',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.bethelcupertino.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Bridges Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.bridgescc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Calvary Armenian Congregational Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://calvaryarmenianchurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Calvary Assembly of God',
    'info': ['Church'],
    'address': '',
    'website': 'https://camilpitas.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Calvary Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://calvary-santa-clara.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Calvary Church (Los Gatos)',
    'info': ['Church'],
    'address': '',
    'website': 'https://calvarylg.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Calvary Church Shining Stars',
    'info': ['Church'],
    'address': '',
    'website': 'https://calvarylg.com/respite',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cambrian Park United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.cambrianparkumc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Campbell Church of Christ',
    'info': ['Church'],
    'address': '',
    'website': 'https://campbellchurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Campbell United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.campbellunited.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Canaan Taiwanese Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.ecanaan.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Captivate Church Milpitas',
    'info': ['Church'],
    'address': '',
    'website': 'https://captivatemilpitas.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cathedral of Faith',
    'info': ['Church'],
    'address': '',
    'website': 'https://cathedraloffaith.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Catholic Youth (Camp Thrive)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.campthrive.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Centerville Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://cpcfremont.churchcenter.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Central Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://centralsj.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Chinese Church In Christ,, San Jose (CCIC)',
    'info': ['Church'],
    'address': '',
    'website': 'https://ccic-sv.org/zh/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Chinese Church in Christ, North Valley (CCIC)',
    'info': ['Church'],
    'address': '',
    'website': 'https://ccicnv.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Chinese Church in Christ, South Valley (CCIC)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.ccic-sv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Christ Church of India',
    'info': ['Church'],
    'address': '',
    'website': 'https://christchurchofindia.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Christ Community Church (Milpitas)',
    'info': ['Church'],
    'address': '',
    'website': 'https://cccmilpitas.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Church In Cupertino',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.churchincupertino.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Church of the Ascension',
    'info': ['Church'],
    'address': '',
    'website': 'https://ascensionsaratoga.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Church of the Chimes',
    'info': ['Church'],
    'address': '',
    'website': 'https://cotconline.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Community Baptist Church of San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.cbcsanjose.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Community Christian Church (Campbell)',
    'info': ['Church'],
    'address': '',
    'website': 'https://community-christian.us/locations/campbell/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Community Christian Church (Morgan Hill)',
    'info': ['Church'],
    'address': '',
    'website': 'https://community-christian.us/locations/morgan-hill/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Crosspoint Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://crosspointchurchsv.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Crossroads Bible Church (San Jose)',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.cbclife.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Crossroads Christian Center',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.crossroadschristiancenter.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Cryy Out Christian Fellowship',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.cryyout.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name':
        'Debre Yibabe Kulbi Kidus Gabriel Ethiopian Orthodox Tewahedo Church',
    'info': ['Church'],
    'address': '',
    'website':
        'https://www.facebook.com/people/Debre-Yibabe-Kulbi-Kidus-Gabriel-Ethiopian-Orthodox-Tewahedo-Church/100021153001833/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Echo Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://echo.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Emmanuel Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.emmanuelbc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Emmanuel Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://epcministry.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Evergreen Valley Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://evcsj.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Evergreen Valley United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.evumc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Family Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://familycommunity.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'First Baptist Church Watsonville',
    'info': ['Church'],
    'address': '',
    'website': 'https://fbcwatsonville.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'First Church San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://fcsanjose.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'First Congregational Church of San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://firstccsj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'First Morning Light Chinese Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.fmlccc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'First Orthodox Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://firstopc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Forerunner Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://archive.frcc.us/english',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Fountain Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.fountainchurch.cc/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Foxworthy Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://foxworthy.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Garden City Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://gardencity.life',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Gateway City Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://mygatewaycity.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Gateway City Church Foundation',
    'info': ['Church'],
    'address': '',
    'website': 'https://mygatewaycity.church/sanjose',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Gereja Kristen Indonesia (GKI) San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.gkisj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Gilroy Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://gilroypres.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Good Samaritan Episcopal Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://goodsamaritanchurch.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Good Shepherd Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.gsccmilpitas.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Good Shepherd South Asian Ministry',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.gssam.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Good Soil Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.goodsoilchurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Gospel Chinese Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.chinesegospel.net/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Grace Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://gracealliancechurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Grace Church of Evergreen',
    'info': ['Church'],
    'address': '',
    'website': 'https://gracechurchevergreen.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Grace Hill Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.grace-hill.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Grace of God Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.ggac-cma.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Grace South Bay',
    'info': ['Church'],
    'address': '',
    'website': 'https://gracesouthbay.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Greek Orthodox Cathedral of The Annunciation',
    'info': ['Church'],
    'address': '',
    'website': 'https://annunciation.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Green Valley Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.greenvalleychristian.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Guiding Light Project Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://guidinglightproject.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Harbor Light',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.harborlight.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Haven Christian Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://havenccc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Hillside Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://hillside.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name':
        'Holy Apostolic Catholic Assyrian Church of the East Mar Yosip Parish',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.maryosipparish.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Holy Cross Romanian Orthodox Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjholycross.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Holy Family Parish',
    'info': ['Church'],
    'address': '',
    'website': 'https://holyfamilysanjose.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Holy Korean Martyrs Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjkoreancatholic.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Holy Spirit Catholic Church Fremont',
    'info': ['Church'],
    'address': '',
    'website': 'https://holyspiritfremont.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Holy Spirit Parish',
    'info': ['Church'],
    'address': '',
    'website': 'https://holyspiritchurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Holy Virgin Cathedral',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.sfsobor.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Home of Christ Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://hoc5.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'House Of Faith Bay Area',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.hof-church.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Immanuel Lutheran Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://ilcsaratoga.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Indian Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.indiancommunitychurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Indonesian Evangelical Church of San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://gii-usa.org/sjc/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Iranian Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://iranian.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Kingsway Community',
    'info': ['Church'],
    'address': '',
    'website': 'https://kingsway.us',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Liberty Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.libertybaptist.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Life Valley Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.lifevalley.church/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Lighthouse Ministries',
    'info': ['Church'],
    'address': '',
    'website': 'https://lighthouseministries.net/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Light of the World Ministries',
    'info': ['Church'],
    'address': '',
    'website': 'https://lotwsj.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Lincoln Glen Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://lincolnglen.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Living Water Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.lwkbc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Lord\'s Grace Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://lordsgrace.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Maranatha Christian Center',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.maranathacc.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Menlo Church San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://menlo.church',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Milpitas Adventist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://milpitaschurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Ministerios Generacion Josue',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.ministeriosgeneracionjosue.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Morgan Hill Bible Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://mhbible.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Neighborhood Bible Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://nbcsj.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Neighborhood Christian Center',
    'info': ['Church'],
    'address': '',
    'website': 'https://myncc.net/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Beginnings Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://nbccbayarea.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Community Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://ncbc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Life Mission Church of Northern California',
    'info': ['Church'],
    'address': '',
    'website': 'https://newlifenorcal.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Life Valley Church San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://newlifevalley.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Spring Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://nowebsite.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Valley Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sites.google.com/thenewvalley.church/home',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'New Vision Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://newvisionchurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Noel Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://nowebsite.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Open Bible Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjobc.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Operation Christmas Child',
    'info': ['Church'],
    'address': '',
    'website': 'https://foxworthy.org/operation-christmas-child.html',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Orchard Valley Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.orchardvalley.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Our Lady of La Vang Parish San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://dmlv.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Our Lady of Refuge Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://ourladyofrefugesj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Our Lady Queen of Martyrs Armenian Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.ourladyqueenofmartyrsacc.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Palo Alto Christian Reformed Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.pacrc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pathway Bible Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://pathwaybible.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Peninsula Bible Church (Cupertino)',
    'info': ['Church'],
    'address': '',
    'website': 'https://pbcc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Peninsula Covenant Church (Redwood City)',
    'info': ['Church'],
    'address': '',
    'website': 'https://wearepcc.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Pine Ridge Reconciliation-Lutheran',
    'info': ['Church'],
    'address': '',
    'website': 'https://pineridgereconciliationcenter.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Presbyterian Church of Los Gatos',
    'info': ['Church'],
    'address': '',
    'website': 'https://pclg.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Prince of Peace Lutheran Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.propeace.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Redeemer Fremont',
    'info': ['Church'],
    'address': '',
    'website': 'https://redeemerfremont.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Redemption Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://myredemption.cc',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'River of Life Christian Church (Santa Clara)',
    'info': ['Church'],
    'address': '',
    'website': 'https://rolcc.net/rolcc2/english-links/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Rohi Christian Fellowship',
    'info': ['Church'],
    'address': '',
    'website': 'https://rohichurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sacred Heart of Jesus',
    'info': ['Church'],
    'address': '',
    'website': 'https://sacredheartjesuschurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Andrew Armenian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://standrewarmchurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Catherine\'s of Alexandria',
    'info': ['Church'],
    'address': '',
    'website': 'https://stca.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Christopher Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://saintchris.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Francis Episcopal Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.stfranciswillowglen.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Francis of Assissi',
    'info': ['Church'],
    'address': '',
    'website': 'https://sfoasj.com',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint James Orthoox Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjorthodox.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint John\'s the Devine Episcopal Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjdmh.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint John Vianney Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.sjvnews.net',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Justin Parish Community',
    'info': ['Church'],
    'address': '',
    'website': 'https://st-justin.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Leo the Great Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://stleochurchsj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Mary\'s Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://smpgilroy.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Mary of the Immaculate Conception Church Los Gatos',
    'info': ['Church'],
    'address': '',
    'website': 'https://stmaryslg.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Nicholas Greek Orthodox Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.saintnicholas.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Timothy\'s Lutheran Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://stlcsj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Victor Catholic Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.stvictorchurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint Volodymyr Ukranian Catholic Mission',
    'info': ['Church'],
    'address': '',
    'website': 'https://stvolodymyrucc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saint William Parish',
    'info': ['Church'],
    'address': '',
    'website': 'https://dsj.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Francisco Chinese Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sfcac.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Christian Alliance',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjcac.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Christian Assembly',
    'info': ['Church'],
    'address': '',
    'website': 'https://english.sjca.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Christian Reformed',
    'info': ['Church'],
    'address': '',
    'website': 'https://sjcrc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sanjosecommunitychurch.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose First Vietnamese Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://tinlanhsanjose.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Valley Korean Church of the Nazarene',
    'info': ['Church'],
    'address': '',
    'website': 'https://thesanjosechurch.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'San Jose Vietnamese Seventh-Day Adventist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sanjosevietnameseca.adventistchurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Santa Clara United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://santaclaraumc.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Santa Teresa Hills Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.sthpc.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Saratoga Federated Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://saratogafederated.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Alliance Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://wp.svac-cma.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Christian Assembly',
    'info': ['Church'],
    'address': '',
    'website': 'https://svcae.cc',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Silicon Valley Seventh-day Adventist Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://svsda.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'South Bay Agape Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://southbayagape.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Southbay Chinese Baptist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://scbc.net/english/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'South Bay Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://sbcc.faithlifesites.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'South Valley Community Church (Gilroy)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.svccchurch.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'St. Joseph of Cupertino',
    'info': ['Church'],
    'address': '',
    'website': 'https://stjosephcupertino.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'St. Mary\'s Syriac Orthodox Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://stmarysbayarea.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Sunnyvale International Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://sunnyvaleic.com/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The Gate International Ministry Center',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.gateinternational.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The Point Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://thepoint.church/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'The River Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://the-river.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Trinity Episcopal Cathedral in the Heart of San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://trinitysj.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Trinity Lutheran Church San Jose',
    'info': ['Church'],
    'address': '',
    'website': 'https://trinitylutheransanjose.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Trinity Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.sjtrinity.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Valley Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://valleychurch.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Venture Christian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.venture.cc',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Vive Church (Mountain View)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.vivechurch.org/mountainview',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Vive Church (San Jose)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.vivechurch.org/sanjose',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Wellspring Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'http://www.wellspringsda.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Wesley United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.wesleysj.net/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Westgate Church (Saratoga)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.westgatechurch.org/saratoga',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Westgate Church (South Hills)',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.westgatechurch.org/southhills',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'West Hills Community Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://westhills.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Westminster Presbyterian Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://www.westpres-sj.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Willow Glen Bible Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://wgbible.org',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Willow Glen United Methodist Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://wgumc.org/',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Woodside Priory Catholic Mission',
    'info': ['Church'],
    'address': '',
    'website': 'https://hungariancatholicmission.com/index.htm',
    'email': 'talkartfunday@gmail.com',
  },
  {
    'name': 'Zion Youngnak Church',
    'info': ['Church'],
    'address': '',
    'website': 'https://eternaljoychurch.org',
    'email': 'talkartfunday@gmail.com',
  }
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
    MyApp(),
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
          colorScheme: ColorScheme.light().copyWith(
            primary: Color.fromARGB(255, 0, 206, 203),
            secondary: Color.fromARGB(255, 168, 248, 168),
            tertiary: Color.fromARGB(255, 255, 237, 102),
            error: Color.fromARGB(255, 255, 94, 91),
            background: Color.fromARGB(255, 255, 255, 234),
            surface: Color.fromARGB(255, 168, 248, 168),
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
  List<Items> _selectedItems = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Items> items;
  List<Items> _results = [];
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
    ListText();
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
    ListText();
  }

  void ListText() {
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
                  decoration: InputDecoration(
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
                    decoration: InputDecoration(
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
                            (_selectedItems.length > 0
                                ? ', ${_selectedItems.length} selected'
                                : ''),
                        style: TextStyle(fontSize: 18),
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
                          shape: RoundedRectangleBorder(
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
                          contentPadding: EdgeInsets.only(left: 10),
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
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
                          shape: RoundedRectangleBorder(
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
                                  EdgeInsets.all(0)),
                            ),
                            child: Text('ⓘ',
                                style: TextStyle(
                                  fontSize: 24, /*color: Colors.black*/
                                )),
                          ),
                          title: Text(_results[index].name),
                          contentPadding: EdgeInsets.only(left: 10),
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
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
                    child: Icon(Icons.mail, color: Colors.black)))
            : BottomAppBar(
                color: theme.colorScheme.primary,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: Icon(
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
        title: Text('Organization Info'),
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
                    Text('Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(item.name + '\n',
                        textAlign: TextAlign.left, softWrap: true),
                    Text('Catagories',
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
                            side: BorderSide(style: BorderStyle.none),
                          );
                        })),
                    Text('\nAddress',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        softWrap: true),
                    Text(item.address + "\n",
                        textAlign: TextAlign.left, softWrap: true),
                    Text('Website',
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
                    Text('Email',
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

  String _fileText = '';
  String msgBody = '';
  String msgSubj = '';

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

      /// normal file
      File _file = File(result.files.single.path!);
      setState(() {
        _fileText = _file.path;
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
        title: Text('Message'),
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
                    decoration: InputDecoration(
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
                      decoration: InputDecoration(
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
                  child: _fileText.isEmpty
                      ? Icon(Icons.note_add_outlined, color: Colors.black)
                      : Icon(Icons.task_outlined, color: Colors.black),
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
                  child: Text('Send Gmail',
                      style: TextStyle(
                          color: (msgBody.isEmpty || msgSubj.isEmpty)
                              ? Colors.grey
                              : Colors.black)),
                  onPressed: () {
                    if (!(msgBody.isEmpty || msgSubj.isEmpty)) {
                      sendEmail();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future sendEmail() async {
    final theme = Theme.of(context);
    final user = await GoogleSignInApi.signin(theme, context);

    if (user == null) {
      /*
      showSnackBar(
          'Google authentication failed', context, theme.colorScheme.error); */
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

    if (_fileText.length > 0) {
      message.attachments.add(FileAttachment(File(_fileText)));
    }

    var i = 0;

    for (var s in selectedItems) {
      try {
        message.recipients = [s.email];
        await send(message, smtpServer);
        i = i + 1;
      } on MailerException catch (e) {
        print(e);
      }
    }
    if (i == selectedItems.length) {
      showSnackBar('Sent all emails', context, theme.colorScheme.secondary);
    } else {
      showSnackBar('Sent ${i} of ${selectedItems.length} emails', context,
          theme.colorScheme.error);
    }
  }
}

void showSnackBar(String text, context, color) {
  final snackBar = SnackBar(
    content: Text(text, style: TextStyle(fontSize: 20, color: Colors.black)),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

class GoogleSignInApi {
  static final _googleSignIn =
      GoogleSignIn(scopes: ['https://mail.google.com/']);

  static Future<GoogleSignInAccount?> signin(theme, context) async {
    /*
    if (await _googleSignIn.isSignedIn()) {
      showSnackBar('Signed in: ${_googleSignIn.currentUser}', context,
          theme.colorScheme.secondary);
      return _googleSignIn.currentUser;
    } else { */
      try {
        final user = await _googleSignIn.signIn();
        showSnackBar('${user} is signed in.', context,
          theme.colorScheme.secondary);
        return user;
      } catch (err) {
        showSnackBar("${err.toString()}", context, theme.colorScheme.error);
      }
    //}
  }

  static Future signOut() => _googleSignIn.signOut();
}
