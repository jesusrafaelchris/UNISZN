import UIKit
import Firebase

class UniveristyChoice: UIViewController {
    
    var docRef: DocumentReference!
    
    let UniversityNameArray = ["Abingdon and Witney College (AWC) ", "University of Aberdeen (ABRDN) ", "University of Abertay Dundee (ABTAY) ", "Aberystwyth University (ABWTH) ", "ABI College (ABIC) ", "Access to Music (ACCM) ", "Accrington and Rossendale College (ARC) ", "College of Agriculture, Food and Rural Enterprise (CAFRE) ", "The Academy of Contemporary Music (ACM) ", "Amersham & Wycombe College (AMWYC) ", "Amsterdam Fashion Academy (AFC) ", "Anglia Ruskin University (ARU) ", "Anglo-European College of Chiropractic (AECC) ", "The Arts University Bournemouth (AUCB) ", "Askham Bryan College (ABC) ", "Aston University (ASTON) ", "Bangor University (BANGR) ", "Barnet and Southgate College (BSC) ", "Barnfield College (BARNF) ", "Barking and Dagenham College (BARK) ", "University Campus Barnsley (BARNC) ", "Basingstoke College of Technology (BCOT) ", "University of Bath (BATH) ", "Bicton College (BICOL) ", "Bath Spa University (BASPA) ", "Bath College (BATHC) ", "University of Bedfordshire (BEDS) ", "Bedford College (BEDF) ", "Birkbeck, University of London (BBK) ", "Birmingham City University (BCITY) ", "Birmingham Metropolitan College (BMET) ", "The University of Birmingham (BIRM) ", "University College Birmingham (BUCB) ", "Bexley College (BEXL) ", "Bishop Burton College (BISH) ", "Bishop Grosseteste University (BGU) ", "BIMM (BIMM) ", "Blackburn College (BLACL) ", "Blackpool and The Fylde College (BLACK) ", "Berkshire College of Agriculture (BCA) ", "University of Bolton (BOLTN) ", "Bolton College (BOLTC) ", "Bournemouth and Poole College (BPCOL) ", "Bournemouth University (BMTH) ", "BPP University (BPP) ", "University of Bradford (BRADF) ", "Bradford College (BRC) ", "Bridgend College (BDGC) ", "Bridgwater and Taunton College (BRIDG) ", "University of Brighton (BRITN) ", "Brighton and Sussex Medical School (BSMS) ", "City College Brighton & Hove (CCBH) ", "Bristol, City of Bristol College (BCBC) ", "University of Bristol (BRISL) ", "Bristol, University of the West of England (BUWE) ", "British College of Osteopathic Medicine (BCOM) ", "Brooklands College (BROOK) ", "Brunel University London (BRUNL) ", "British School of Osteopathy (BSO) ", "University of Buckingham (BUCK) ", "Brooksby Melton College (BROKS) ", "Bury College (BURY) ", "Buckinghamshire New University (BUCKS) ", "Bromley College of Further and Higher Education (BCFHE) ", "Calderdale College (CALD) ", "University of Cambridge (CAM) ", "Cambridge Education Group Limited (CSVPA) ", "Cambridge Regional College (CRC) ", "Canterbury Christ Church University (CANCC) ", "Canterbury College (CANT) ", "Capel Manor College (CMC) ", "Cardiff University (CARDF) ", "Cardiff Metropolitan University (CUWIC) ", "Coleg Sir Gar (CARM) ", "Carshalton College (CARC) ", "Central Bedfordshire College (CBED) ", "University of Central Lancashire (UCLan) (CLANC) ", "Central Film School London (CFSL) ", "The Royal Central School of Speech and Drama (CSSD) ", "City of Glasgow College (CGC) ", "University of Chester (CHSTR) ", "Chesterfield College (CHEST) ", "Chichester College (CHCOL) ", "University of Chichester (CHICH) ", "City University London (CITY) ", "City College Coventry (CCC) ", "City and Islington College (CIC) ", "City of Sunderland College (CSUND) ", "Cleveland College of Art and Design (CLEVE) ", "Cliff College (CLIFC) ", "City of London College (CLC) ", "Colchester Institute (CINST) ", "Cornwall College (CORN) ", "Courtauld Institute of Art (University of London)(CRT) ", "City College Plymouth (CPLYM) ", "Coventry University (COVN) ", "The Condé Nast College of Fashion & Design (CNCFD) ", "Craven College (CRAV) ", "Creative Academy (CRA) ", "University Centre Croydon (Croydon College) (CROY) ", "University for the Creative Arts (UCA) (UCA) ", "University of Cumbria (CUMB) ", "De Montfort University (DEM) ", "Derby College (DCOL) ", "University of Derby (DERBY) ", "Doncaster College (DONC) ", "Duchy College (DUCHY) ", "Dudley College of Technology (DUDL) ", "University of Dundee (DUND) ", "Durham University (DUR) ", "Ealing, Hammersmith and West London College (EHWL) ", "University of East Anglia (EANG) ", "University of East London (ELOND) ", "East Riding College (ERC) ", "Easton and Otley College (an Associate College of UEA) (EASTC) ", "East Surrey College (ESURR) ", "Edge Hotel School (EHS) ", "Edge Hill University (EHU) ", "University of Edinburgh (EDINB) ", "Edinburgh Napier University (ENAP) ", "University of Essex (ESSEX) ", "ESCP Europe Business School (ESCP) ", "European School of Osteopathy (ESO) ", "Exeter College (EXCO) ", "University of Exeter (EXETR) ", "Fairfield School of Business (FSB) ", "Falmouth University (FAL) ", "University Centre Farnborough (FCOT) ", "Furness College (FURN) ", "Futureworks (FUWO) ", "Gateshead College (GATE) ", "University of Glasgow (GLASG) ", "Glasgow Caledonian University (GCU) ", "Glasgow School of Art (GSA) ", "Gloucestershire College (GCOL) ", "University of Gloucestershire (GLOS)\t ", "Glyndwr University (GLYND) ", "Goldsmiths, University of London (GOLD) ", "Gower College Swansea (GCOLS) ", "University of Greenwich (GREEN) ", "Greenwich School of Management (GSM London) (GSM) ", "University Centre Grimsby (GRIMC) ", "Guildford College (GUILD) ", "Hadlow College (HADCO) ", "Halesowen College (HALES) ", "Harrogate College (HARRC) ", "The College of Haringey, Enfield and North East London (CHEN) ", "Harrow College (HARCO) ", "Harper Adams University (HAUC) ", "Havering College of Further & Higher Education (HAVC) ", "Hereford College of Arts (HERE) ", "Heart of Worcestershire College (HWC) ", "Hartpury University Centre (HARTP) ", "Heriot-Watt University, Edinburgh (HW) ", "University of Hertfordshire (HERTS) ", "Hertford Regional College (HRC) ", "University of the Highlands and Islands (UHI) ", "Holy Cross Sixth Form College and University Centre (HCSFC) ", "Hopwood Hall College (HOPH) ", "University of Huddersfield (HUDDS) ", "Hugh Baird College (HBC) ", "University of Hull (HULL) ", "Hull College (HULLC) ", "Hull York Medical School (HYMS) ", "Hult International Business School (HULT) ", "The Institute of Contemporary Music Performance (ICMP) ", "Istituto Marangoni London (INMAR) ", "Imperial College London (IMP) ", "ifs University College (IFSS) ", "Islamic College for Advanced Studies (ICAS) ", "West Kent and Ashford College (KCOLL) ", "Keele University (KEELE) ", "Kensington and Chelsea College (KCC) ", "Kensington College of Business (KCB) ", "Kendal College (KEND) ", "University of Kent (KENT) ", "King's College London (University of London) (KCL) ", "Kingston College (KCOL) ", "Kingston University (KING) ", "Kingston Maurward College (KMC) ", "Kirklees College (KIRK) ", "KLC School of Design (KLC) ", "Knowsley Community College (KNOW) ", "Lewisham Southwark College (LSCO) ", "Lakes College - West Cumbria (LCWC) ", "Lancaster University (LANCR) ", "University of Law (incorporating College of Law) (LAW) ", "Leeds City College (LCCOL) ", "University of Leeds (LEEDS) ", "Leeds Trinity University (LETAS) ", "Leeds Beckett University (LMU) ", "Leeds Arts University (LAD) ", "Leeds College of Music (UCAS) (LCM) ", "Leeds College of Building (LCB) ", "University of Leicester (LEICR) ", "Leicester College (LCOLL) ", "University of Lincoln (LINCO) ", "University of Liverpool (LVRPL) ", "Lincoln College (LINCN) ", "The City of Liverpool College (COLC) ", "Liverpool Hope University (LHOPE) ", "The Liverpool Institute for Performing Arts (LIVIN) ", "Liverpool John Moores University (LJMU) (LJM) ", "Coleg Llandrillo (LLC) ", "UCK Limited (LCUCK) ", "ARU London (LCA) ", "London Metropolitan University (LONMT) ", "London School of Commerce (LSC) ", "London School of Economics and Political Science (University of London) (LSE) ", "London School of Business and Management (LSBM) ", "London South Bank University (LSBU) ", "London School of Marketing Limited (LSM) ", "Loughborough College (LOUGH) ", "Loughborough University (LBRO) ", "LCCM (L83) ", "The Manchester College (MCOL) ", "University of Manchester (MANU) ", "Manchester Metropolitan University (MMU) ", "Medipathways College (MEDIP) ", "Medway School of Pharmacy (MEDSP) ", "Coleg Menai (MENAI) ", "Met Film School (MFS) ", "Middlesex University (MIDDX) ", "Mid-Kent College of Higher and Further Education (MKENT) ", "Mont Rose College (MRC) ", "Milton Keynes College (MKCOL) ", "Moulton College (MOULT) ", "Myerscough College (MYERS) ", "Nazarene Theological College (NAZ) ", "NPTC Group (NEATH) ", "University of Newcastle upon Tyne (NEWC) ", "Newcastle College (NCAST) ", "New College Durham (NCD) ", "New College Nottingham (NCN) ", "Newham College London (NHAM) ", "New College Stamford (NCS) ", "Newman University, Birmingham (NEWB) ", "University of Northampton (NTON) ", "Norwich University of the Arts (NUA) ", "Northbrook College Sussex (NBRK) ", "North East Surrey College of Technology (NESCT) ", "Norland Nursery Training College Limited (NNCT) ", "New College of the Humanities (NCHUM) ", "North Hertfordshire College (NHC) ", "Northampton College (NORCO) ", "North Lindsey College (NLIND) ", "Northumbria University (NORTH) ", "Northumberland College (NUMBC) ", "North Warwickshire and Hinckley College (NWHC) ", "Norwich City College of Further and Higher Education (NCC) ", "University of Nottingham (NOTTM) ", "North Kent College (NWKC) ", "Nottingham Trent University (NOTRE) ", "University Campus Oldham (UCO) ", "The Open University (OU) [7] ", "Oaklands College (OAK) ", "Oxford Business College (OBC) ", "Activate Learning (Oxford, Reading, Banbury & Bicester) (OXCH) ", "Oxford University (OXF) ", "Oxford Brookes University (OXFD) ", "University of London Institute in Paris (PARIS) ", "Pearson College London (including Escape Studios) (PEARS) ", "Pembrokeshire College (PEMB) ", "Petroc (PETRO) ", "Peter Symonds College (PSC) ", "University Centre Peterborough (PETER) ", "Plumpton College (PLUMN) ", "Plymouth University (PLYM) ", "University of St Mark and St John (PMARJ) ", "Plymouth College of Art (PCAD) ", "Point Blank Music School (POINT) ", "University of Portsmouth (PORT) ", "Queen Margaret University, Edinburgh (QMU) ", "Queen Mary University of London (QMUL) ", "The Queen's University Belfast (QBELF) ", "Ravensbourne (RAVEN) ", "University of Reading (READG) ", "Reaseheath College (RHC) ", "Regent's University London (RBS) ", "Richmond, the American International University (RICH) ", "Arden University (RDI) (RDINT) ", "Robert Gordon University (RGU) ", "Roehampton University (ROE) ", "Rose Bruford College (ROSE) ", "Rotherham College of Arts and Technology (RCAT) ", "Royal Agricultural University, Cirencester (RAU) ", "Royal Academy of Dance (RAD) ", "Royal Holloway, University of London (RHUL) ", "Royal Veterinary College (University of London) (RVET) ", "Royal Welsh College of Music and Drama (Coleg Brenhinol Cerdd a Drama Cymru) (RWCMD) ", "Runshaw College (RUNSH) ", "Ruskin College, Oxford (RUSKC) ", "SRUC (SRUC) ", "University of Salford (SALF) ", "SAE Institute (SAE) ", "Selby College (SELBY) ", "Sandwell College (SAND) ", "SOAS (University of London) (SOAS) ", "Salford City College (SALCC) ", "University of Sheffield (SHEFD) ", "South & City College Birmingham (SCCB) ", "Sheffield Hallam University (SHU) ", "Sheffield College (SCOLL) ", "Shrewsbury College of Arts and Technology (SHREW) ", "Solihull College & University Centre (SOLI) ", "University of Southampton (SOTON) ", "Southampton Solent University (SOLNT) ", "South Devon College (SDEV) ", "University Centre Sparsholt (SPAR) ", "Southport College (SOCO) ", "University of St Andrews (STA) ", "South Cheshire College (SCC) ", "Havant and South Downs College (SDC) ", "South Essex College, University Centre Southend and Thurrock (SEEC) ", "St George's, University of London (SGEO) ", "South Thames College (STHC) ", "University Centre St Helens (STHEL) ", "South Tyneside College (STYNE) ", "South Gloucestershire and Stroud College (SGSC) ", "Spurgeon's College (SPUR) ", "St. Mary's College, Blackburn (SMC) ", "St Mary's University, Twickenham, London (SMARY) ", "Staffordshire University (STAFF) ", "University of Stirling (STIRL) ", "Stockport College (STOCK) ", "University of Strathclyde (STRAT) ", "Stranmillis University College: A College of Queen's University Belfast (SUCB) ", "University Campus Suffolk (UCS) ", "Sussex Coast College Hastings (SCCH) ", "University of Sunderland (SUND) ", "University of Surrey (SURR) ", "Sussex Downs College (SDCOL) ", "University of Sussex (SUSX) ", "Swansea University (SWAN) ", "Swindon College (SWIN) ", "Tameside College (TAMES) ", "Teesside University (TEES) ", "Tottenham Hotspur Foundation (THF) ", "University of Wales Trinity Saint David (UWTSD Carmarthen / Lampeter) (UWTSD) ", "Truro and Penwith College (TRURO) ", "Tyne Metropolitan College (TMC) ", "UCFB (UCFB) ", "UK College of Business & Computing (UKCBC) ", "University of Ulster (ULS) ", "University of the West of Scotland (UWS) ", "University of the Arts London (UAL) ", "UCL (University College London) (UCL) ", "Uxbridge College (UXBC) ", "Seevic College (SEEV) ", "university of South Wales (USW) ", "University of West London (UWL) ", "Wakefield College (WAKEC) ", "Walsall College (WALS) ", "University of Warwick (WARWK) ", "Warwickshire College (WARKS) ", "College of West Anglia (WESTA) ", "West Cheshire College (WCC) ", "West Herts College, Watford Associate College of University of Hertfordshire (WHCW) ", "Vision West Nottinghamshire College (Vision University Centre) (WNC) ", "Weston College (WSTON) ", "University of Westminster (WEST) ", "City of Westminster College (WESCL) ", "Westminster Kingsway College (WESTC) ", "West Thames College (WTC) ", "Weymouth College (WEYC) ", "Wigan and Leigh College (WIGAN) ", "Wirral Metropolitan College (WMC) ", "Wiltshire College (WILTC) ", "University of Wolverhampton (WOLVN) ", "University of Winchester (WIN) ", "University of Worcester (WORCS) ", "Writtle College (WRITL) ", "Yeovil College (YEOV) ", "The University of York (YORK) ", "York College (York) (YCOLL) ", "York St John University (YSJ) "]


    var searchedUniversity = [String]()
    var searching = false
    
    
    @IBOutlet var UniSearch: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.UniSearch.becomeFirstResponder()
            if Auth.auth().currentUser != nil {
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let docRef = Firestore.firestore().collection("users").document(userID)
            
           } else {
             // No user is signed in.
             // ...
           }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    }
}

extension UniveristyChoice: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedUniversity.count
        } else {
            return UniversityNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if searching {
            cell?.textLabel?.text = searchedUniversity[indexPath.row]
        } else {
            cell?.textLabel?.text = UniversityNameArray[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt
       indexPath: IndexPath) {
       print("row selected : \(indexPath.row)")
        let cell = tableView.cellForRow(at: indexPath)!
        let choice = cell.textLabel!.text ?? ""
        print(choice)
        let datatoSave: [String:Any] = ["University":choice]
        let docRef = Firestore.firestore()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let document = Firestore.firestore().collection("users").document(userID)
        let UserUnis = Firestore.firestore().collection("User-Universities").document(choice)
        let Userid: [String:Any] = [userID: true]
        UserUnis.setData(Userid, merge:true)
        document.setData(datatoSave,merge: true)
        self.dismiss(animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension UniveristyChoice: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedUniversity = UniversityNameArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.dismiss(animated: true, completion: nil)
        
        tblView.reloadData()
        
    }
    
}
