//
//  ImpressumView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 26/07/2024.
//

import SwiftUI

struct ImpressumView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Impressum")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)  // swiftlint:disable:this superfluous_disable_command
                Text("Angaben gemäß § 5 TMG")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("""
                Pablo Cigoy
                CateringManager App
                BornholmerStr. 13
                10439 Berlin
                Deutschland
                """)
                Text("Kontakt")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("""
                Telefon: +49 123 456 789
                E-Mail: pablocigoy@gmail.com
                """)
                Text("Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("""
                                Pablo Cigoy
                                CateringManager App
                                BornholmerStr. 13
                                10439 Berlin
                                Deutschland
                """)
                Text("Streitschlichtung")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("""
                Die Europäische Kommission stellt eine Plattform zur Online-Streitbeilegung (OS) bereit: https://ec.europa.eu/consumers/odr.
                Unsere E-Mail-Adresse finden Sie oben im Impressum.
                """)
                Text("""
                Wir sind nicht bereit oder verpflichtet, an Streitbeilegungsverfahren vor einer Verbraucherschlichtungsstelle teilzunehmen.
                """)
                Text("Haftung für Inhalte")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("""
                Als Diensteanbieter sind wir gemäß § 7 Abs.1 TMG für eigene Inhalte auf diesen Seiten nach den allgemeinen Gesetzen verantwortlich. Nach §§ 8 bis 10 TMG sind wir als Diensteanbieter jedoch nicht verpflichtet, übermittelte oder gespeicherte fremde Informationen zu überwachen oder nach Umständen zu forschen, die auf eine rechtswidrige Tätigkeit hinweisen.
                Verpflichtungen zur Entfernung oder Sperrung der Nutzung von Informationen nach den allgemeinen Gesetzen bleiben hiervon unberührt. Eine diesbezügliche Haftung ist jedoch erst ab dem Zeitpunkt der Kenntnis einer konkreten Rechtsverletzung möglich. Bei Bekanntwerden von entsprechenden Rechtsverletzungen werden wir diese Inhalte umgehend entfernen.
                """)
                Text("Haftung für Links")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("""
                Unser Angebot enthält Links zu externen Websites Dritter, auf deren Inhalte wir keinen Einfluss haben. Deshalb können wir für diese fremden Inhalte auch keine Gewähr übernehmen. Für die Inhalte der verlinkten Seiten ist stets der jeweilige Anbieter oder Betreiber der Seiten verantwortlich. Die verlinkten Seiten wurden zum Zeitpunkt der Verlinkung auf mögliche Rechtsverstöße überprüft. Rechtswidrige Inhalte waren zum Zeitpunkt der Verlinkung nicht erkennbar.
                Eine permanente inhaltliche Kontrolle der verlinkten Seiten ist jedoch ohne konkrete Anhaltspunkte einer Rechtsverletzung nicht zumutbar. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Links umgehend entfernen.
                """)
                Text("Urheberrecht")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("""
                Die durch die Seitenbetreiber erstellten Inhalte und Werke auf diesen Seiten unterliegen dem deutschen Urheberrecht. Die Vervielfältigung, Bearbeitung, Verbreitung und jede Art der Verwertung außerhalb der Grenzen des Urheberrechtes bedürfen der schriftlichen Zustimmung des jeweiligen Autors bzw. Erstellers. Downloads und Kopien dieser Seite sind nur für den privaten, nicht kommerziellen Gebrauch gestattet.
                Soweit die Inhalte auf dieser Seite nicht vom Betreiber erstellt wurden, werden die Urheberrechte Dritter beachtet. Insbesondere werden Inhalte Dritter als solche gekennzeichnet. Sollten Sie trotzdem auf eine Urheberrechtsverletzung aufmerksam werden, bitten wir um einen entsprechenden Hinweis. Bei Bekanntwerden von Rechtsverletzungen werden wir derartige Inhalte umgehend entfernen.
                """)
            }
            .padding()
        }
        .navigationTitle("Impressum")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ImpressumView_Previews: PreviewProvider {
    static var previews: some View {
        ImpressumView()
    }
}