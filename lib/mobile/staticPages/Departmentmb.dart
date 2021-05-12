import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:mbmelearning/Widgets/Buttons.dart';
import 'package:mbmelearning/Widgets/bottomBar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:mbmelearning/constants.dart';



class DepartmentMB extends StatefulWidget {
  @override
  _DepartmentMBState createState() => _DepartmentMBState();
}

class _DepartmentMBState extends State<DepartmentMB> {
  BannerAd _bannerAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: kBannerAdsId);
    _bannerAd = createBannerAd()..load();
  }
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 1),
            (){
          _bannerAd.show();
        }
    );
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: ZStack([
          VStack([
            60.heightBox,
            "About MBM".text.color(kFirstColour).xl2.bold.make(),
            10.heightBox,
            "MBM Engineering College is one of the oldest engineering colleges in India. Established on 15th August 1951 by the government of Rajasthan, the college boasts of its high academic & technical standards. Considered as the pioneering Technical Institution of the State, it offers a gamut of courses both at PG and UG level. The college is committed to providing its students with an education that combines rigorous academic study and developing a far more ambitious, integrated and influential environment that will best serve the nation.".text.xl.make(),
            20.heightBox,
            "Faculty".text.color(kFirstColour).xl2.bold.make(),
            10.heightBox,
            "The faculty of MBM engineering college is highly qualified who have obtained their degrees from leading technical institutions in India and abroad.The contribution of the faculty members from their respective departments has been significant to the country’s growth in science and technology, being members of various international and national conferences and seminars of utmost importance. Besides research work the faculty members have over 20 years of experience in teaching graduate as well as post graduate students. The talented teachers have established competence and have authored number of books in their fields of specialization. Late Prof. BC Punamia, Former Dean & Head of Civil Engineering Department is the author of more than 20 technical course books for engineering students.".text.xl.make(),
            20.heightBox,
            "Students".text.color(kFirstColour).xl2.bold.make(),
            10.heightBox,
            "A graduate degree program at MBM compounded by a comprehensively devised course structure , highly advanced laboratories and most importantly the experience of research faculty is a perfect platform for students to enhance their technical skills. Our students spent over 3 months in industry as part of their Practical training. This exposes them with real life applications of their course work and acquaints them with a professional working environment. Over the years our students have continuously proved their mettle in various competitive examinations like IES,GATE,GRE Our students are involved in a broad range of volunteer activities in the community. Outside of the classroom, active participation in self-developing clubs , staff organizations and management groups help students to groom their over-all personality.".text.xl.make(),
            20.heightBox,
            "Remarkable Achievements".text.color(kFirstColour).xl2.bold.make(),
            10.heightBox,
            "Educational Multimedia Research Centre (EMMRC), Jodhpur a production and research centre for educational films for UGC-CWCR, has received national recognition for its contribution in the field of electronic media. The Center is fully funded by the University Grants Commission and it is an organization with well-equipped studio and highly trained staff. The TANDEM Computer is available only in this university in North India which is unique in the entire country. This is a parallel online architecture used by entire faculty. The cost of system is Rs.300.00 Lacs. The Computer Science and Engineering Department has collaboration with IBM USA for training. National/international recognition of the facultymember of IE(I); ACM(USA); IEEE (USA)".text.xl.make(),
            30.heightBox,
            "Departments".text.color(kFirstColour).xl2.bold.make(),
            VxBox().color(kFirstColour).size(60, 2).make(),

            10.heightBox,
            "Department of Electrical Engineering".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "The Department of Electrical Engineering, established in 1958, has been recognized world over for excellence in academics. It is the one of the largest departments in the institute and is continuously striving to improve the quality of education to meet the needs of industries and to excel in academics and research.".text.make(),
            "VISION".text.bold.make(),
            "To be the coveted Electrical Engineering Department for imparting state of the art technical education and skills to budding Engineers for transforming them into globally-competent technocrats, researchers, consultants and entrepreneurs having high professional ethics.".text.make(),
            "MISSION".text.bold.make(),
            "M01: To produce Electrical Engineers having strong fundamental knowledge, high technical expertise, exposure to research with modern tools of design and high end technology.\n"
          "M02: To inculcate the capability of applying the acquire knowledge for developing cutting edge technologies.\n"
      "M03: To create a conducive environment for learning and innovative research in which continuing education can flourish.\n"
      "M04: To provide a platform for interface between industry and academia for disseminating state of art technology for sustainable socio-economic progress.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "Doctor of Philosophy (Ph.D.) in Electrical Engineering.\n"
          "Master of engineering (M.E.) in Power Systems Engineering (full time & part time).\n"
    "Master of Engineering in Control Systems Engineering (full time & part time).\n"
    "Bachelor of Engineering (B.E.) in Electrical Engineering (full time).".text.make(),
            "RESEARCH AREAS".text.bold.make(),
            "Major research in the department are Pattern Recognition, Computational Neuroscience, Soft Computing, Intelligent Controllers, Power System Security, Automation, Handwritten Character Recognition, Machine Learning, Artificial Intelligence, Computer Modelling and Analysis of Bio-signals. In these subjects, research papers are regularly published in journals and conferences at national and international levels.".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-electrical-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbmacin.rf.gd/wp-content/uploads/2021/01/Electrical-Department-Brocture-converted.pdf");
                },
              )
            ]).centered(),

            10.heightBox,
            "Department of Mechanical Engineering".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "Department of Mechanical Engineering was established in year 1952 to impart quality education in the area of Mechanical Engineering. The department has specialization in Thermal Engineering, Design Engineering, Production & Industrial Engineering, Supply Chain Management, Performance Measurement, Information Systems, Solid Mechanics, and Structural Design.".text.make(),
            "VISION".text.bold.make(),
            "To provide quality technocrat compatible with global standard in the field of mechanical engineering who can contribute to society through innovations, entrepreneurship & sustainable development.".text.make(),
            "MISSION".text.bold.make(),
            "M01: To impart highest quality in fundamentals, technical knowledge & scientific education to the learners to make them globally competitive mechanical engineers\nM02: To promote liaison with world class industries & educational institutions for excellence in teaching, research & consultancy practices.\nM03: To make students, life-long learners, ethically and technically capable to build their careers in terms of professions and personality".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "1. B.E. (Mechanical Engineering)\n"
          "2. M.E. (Thermal, Design, P&I)\n"
        "3. Ph.D. (Mechanical Engineering)".text.make(),
            "ACHIEVEMENTS OF OUR STUDENTS".text.bold.make(),
            "Sport (basketball) bronze medal at Jai Narain Vyas University, Jodhpur.\n"
            "Participants in International Conference on Advanced and Futuristic Trends in Mechanical and Materials Engineering at IIT Roper (05-07 December 2019).\n"
            "Students organized a technical fest at M.B.M. Engineering College, Jodhpur.\n"
            "Participation at National and State level in Sae-Baja-2019.\n"
            "NEI IDEA Factory, Project title on Hyper physical use of AI in HVAC system".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-mechanical-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbm.ac.in/wp-content/uploads/2021/01/Mechanical_Placement_Brochure.pdf");
                },
              )
            ]).centered(),

            10.heightBox,
            "Department of Computer Science & Engineering".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "The Department of Computer Science & Engineering was established in the year 1992 with the intake of 33 students in B.E. Computer Science & Engineering. Progressively, the Department has grown up with the pace of technological development and started more courses as required by demand of society, time and industry.".text.make(),
            "VISION".text.bold.make(),
            "To be a leader in providing excellent educational, research and techno-entrepreneurial resources in the eld of Computer Science and Engineering to meet out the existing, future and interdisciplinary needs of industry and society.".text.make(),
            "MISSION".text.bold.make(),
            "M01: To provide quality education through state-of-the-art teaching-learning methods to produce competent graduates and post graduates in the field of Computer Science, IT and Applications.\n"
            "M02: To create facilities and resources to discover and disseminate knowledge to students for the advancement of society and industry.\n"
            "M03: To partner and collaborate with industry, government and R&D institutions to pace with latest research & sustainable technologies and ensure quality assurance.\n"
            "M04: To impart innovative and entrepreneurial outlook, values, ethics and vision to students to make them responsible professionals and global citizens.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "B.E. in Computer Science & Engineering (4 Years Degree Course) started 1990\n"
          "B.E. in Information Technology (SFS – 4 Years Degree Course) started in 2000\n"
    "M.E. with specialization in Computer Science & Engineering started in 2006\n"
    "Ph.D in Computer Science started in 2009\n"
    "Master of Computer Applications (3 Years course) started in 1988".text.make(),
            "ACHIEVEMENTS OF OUR STUDENTS".text.bold.make(),
            "In GATE 2019, Jay Bansal (CSE), Srinivas Paliwal (CSE) and Jyoti Sharma (IT) secured AIR 2, 90, and 192 respectively.\n"
          "Prashant Singh (IT) received a full scholarship from North-Eastern University, USA for pursuing PhD in 2019.\n"
        "Vipin Kumar (CSE) received an o-campus placement at Media. Net with a CTC package of INR 29.75 LPA.\n"
    "Jay Bansal (CSE) received the Best Paper Award at International Conference on NascenTechnologis in Engineering, 2019 for his paper on using Blockchain for E-Voting.".text.make(),
    10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-computer-science-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbm.ac.in/wp-content/uploads/2020/12/brochure_placement-2.pdf");
                },
              )
            ]).centered(),


            10.heightBox,
            "Department of Production & Industrial Engineering".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "Department was established in year 1990 to impart quality education in the area of PRODUCTION AND INDUSTRIAL ENGINEERING. Recently, the department has started an interdisciplinary post graduate program in Industrial Engineering and Management. This course has high demand in various industries. The department has well equipped CAD/CAM, Robotics, Industrial Engineering, Product design and Development Laboratories. The department has specialization in Manufacturing and Industrial Engineering, Automation (CAD/CAM&CAPP), Supply Chain Management, Performance Measurement, Information Systems. Production & industrial engineering is a branch of engineering concerned with the development, improvement, implementation and evaluation of integrated systems of people, money, knowledge, information, equipment, energy material and process. It also deals wit designing new prototypes to help save money and make the prototype better. Industrial engineering draws upon the principles and methods of engineering analysis and synthesis, as well as mathematical, physical and social sciences together with the principles and methods of engineering analysis and design to specify, predict, and evaluate the results to be obtained from such systems. Production & Industrial engineering is a course which equips a person with the vital technical, analytical and managerial skills required for production & management of time, labour, and resources in industry for it to run successfully.".text.make(),
            "VISION".text.bold.make(),
            "To be a centre of high quality education and research in the field of production and industrial engineering for meeting the dynamic needs of enterprises".text.make(),
            "MISSION".text.bold.make(),
            "M01: “To generate competent engineering professionals possessing advanced knowledge in the field of production and industrial engineering”.\n"
            "M02: “To develop techno-managers having excellent technical and managerial skills with high regard for ethical values contributing to overall development”.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "Under Graduate Program: B.E Production & Industrial Engineering.\n"
          "Post Graduate Program:M.E. : Industrial Engineering and Management (This course is open to graduates of all branches of engineering and technology.)\n"
        "Ph.D:Production and Industrial Engineering.".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-production-and-industrial-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbmacin.rf.gd/wp-content/uploads/2021/01/Production-and-Industrial-Department-converted.pdf");
                },
              )
            ]).centered(),

            10.heightBox,
            "Department of Chemical Engineering".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "".text.make(),
            "VISION".text.bold.make(),
            "".text.make(),
            "MISSION".text.bold.make(),
            "The Department of Chemical Engineering is committed to providing its students with an education that combines rigorous academic study and developing a far more ambitious, integrated and inertial environment that will best serve the nation.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "B.E. in Chemical Engineering\n"
            "PhD program in various domains of Chemical Engineering".text.make(),
            "ACHIEVEMENTS".text.bold.make(),
            "The Department has been well known for its infrastructure and laboratories.\n"
          "Our Teachers have completed many sponsored research projects and hold several patents in their field.\n"
      "30 publications in SCI Journals and 40 publications in conference proceedings.\n"
      "IIChe Student Chapter and Chemical Engineering Magazine (Chemibuzz).".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-chemical-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbmacin.rf.gd/wp-content/uploads/2021/01/chemical_department_brochure.pdf");
                },
              )
            ]).centered(),

            10.heightBox,
            "Department of Mining Engineering".text.color(kFirstColour).xl.bold.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "Four-year B.E. in Mining Engineering (48 students’ intake)\n"
          "Two-year M.E. in Metalliferous Mining (15 students’ intake)Ph.D. programme.".text.make(),
            "RESEARCH AREAS".text.bold.make(),
            "The postgraduate research leading to Ph.D. has been carried out in the area of rock fragmentation by blasting."
          "For Master’s Degree students have worked in the areas of mine environment, slope stability and dimensional stone mining."
      "Research projects have been completed in the eld of rock mechanics, environment, rock fragmentation, remote sensing and GIS application.".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-mining-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbmacin.rf.gd/wp-content/uploads/2021/01/Mining_department.pdf");
                },
              )
            ]).centered(),

            10.heightBox,
            "Department of Electronics & Comm. Engineering".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "Electronics & Communication department was established in 1972. "
          "In 2010 Electronics & Electrical and Electronics & Computers Engineering programme were also included. "
      "ME program in Digital Communication was started in 1986. "
      "Department also runs PhD program in ECE.".text.make(),
            "VISION".text.bold.make(),
            "To impart quality education in the elds of electronics , communication, computers & electrical engineering to the students with in depth knowledge of subject & to achieve academic and research excellence.".text.make(),
            "ACHIEVEMENTS".text.bold.make(),
            "Two teams were selected at Smart India Hackathon Internal Hackathon: power rangers and ozo. "
            "4 members team designed special robot for army to carry 50kg load was selected in DRDO. "
            "Ajay P Vyas developed a technique for dumb people using synthesis speech via surface electromyography for laryngectomy rehabilitation with AIIMS Jodhpur.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "Master of Electronics & Communication Engineering (Digital Communication Engineering) \n"
            "Bachelor of Engineering.\n"
            "Post Graduate Diploma Consumer Electronics & TV Technology".text.make(),
            "Basic & Advanced facilities".text.bold.make(),
            "Telematics laboratory.\n"
          "Microprocessor Development System.\n"
      "Fully Computerized PCB fabrication facility\n"
      "Logic Analyser.\n"
          "Spectrum Analyser.".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-electronics-and-communication-engineering/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbmacin.rf.gd/wp-content/uploads/2021/01/ELECTRONICS-AND-COMMUNICATION-DEPARTMENT-BROCTURE-converted.pdf");
                },
              )
            ]).centered(),

            10.heightBox,
            "Department of Civil & Structural Engineering".text.color(kFirstColour).xl.bold.make(),
            "VISION".text.bold.make(),
            "To produce a quality human resource of world-class standard who will excel in Education and Consultancy in the eld of Civil Engineering by imbibing wide-range of skills in cutting-edge technology with emphasis on Sustainable Development.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "B.E. in Civil Engineering\n"
          "M.E. in Environmental Engineering, Geo-Technical Engineering, Transportation Engineering and Structural Engineering\n"
      "PhD program in various areas of Civil and Structural Engineering".text.make(),
            "ACHIEVEMENTS".text.bold.make(),
            "The Department has been well known for its students securing the top ranks in national competitive examinations like UPSE-ESE, GATE, SSC-JE\n"
          "working in prestigious government institutions like DRDO, NHAI, CPWD, ISRO and other state/local govt. authorities like PWD, PHED, GWD\n"
          "Our alumni have also been recruited by PSUs like HPCL, BPCL, BHEL, SAIL, NHPC, NTPC, IOCL Students have excelled in the eld of Research and Developments and are currently progressing in top-notch technical institutions like IITs and NITs.".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore Civil",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-civil-engineering/");
                },
              ),
              CKOutlineButton(
                width: context.percentWidth*40,
                buttonText: "KnowMore Structural",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/structural-engineering/");
                },
              ),
            ]).centered(),
            10.heightBox,
            CKGradientButton(
              width: context.percentWidth*40,
              buttonText: "Download Brochure",
              onprassed: (){
                launch("http://mbm.ac.in/wp-content/uploads/2021/01/Department-of-Civil-Structural-Engineering_Placement_Brochure.pdf");
              },
            ).centered(),

            10.heightBox,
            "Department of Architecture & Town Planning".text.color(kFirstColour).xl.bold.make(),
            "ABOUT".text.bold.make(),
            "The Department of Architecture started functioning with the approval of AICTE from the academic session 1998-99 with annual intake of 30 students. "
          "The new Department of Architecture aims at exploring and documenting the rich art, craft and cultural heritage of the region and at the same time move ahead with modern development in all walks of life that forms the basis of architectural education programme leading to the Degree of Bachelor of Architecture. "
      "In addition to the basic facilities available in the faculty the Department of Architecture will have to create Studios, Computer Center well equipped with latest software and photography & audio- visuals estimated to about Rs. 21.00 millions.".text.make(),
            "PROGRAMS OFFERED".text.bold.make(),
            "B.E. Building and Construction\n"
          "B.Arch.".text.make(),
            10.heightBox,
            HStack([
              CKOutlineButton(
                buttonText: "KnowMore",
                onprassed: (){
                  launch("http://www.jnvu.co.in/department/deptt-of-architecture-town/");
                },
              ),
              CKGradientButton(
                width: context.percentWidth*40,
                buttonText: "Download Brochure",
                onprassed: (){
                  launch("http://mbm.ac.in/wp-content/uploads/2021/01/ARCH_-AND_TOWN-PLANNING_PLACEMENT_BROCHURE.pdf");
                },
              )
            ]).centered(),
            20.heightBox,
            BottomBar(),
          ]).scrollVertical(physics: AlwaysScrollableScrollPhysics()).p(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: VxBox(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: kFirstColour,
                  ),
                ).color(kSecondColour).size(50,40).make(),
              ),
              VxBox(
                child: "Departments".text.color(kFirstColour).bold.xl3.makeCentered(),
              ).color(kSecondColour).size(200,40).make(),
            ],
          ),
        ]),
      ),
    );
  }
}
